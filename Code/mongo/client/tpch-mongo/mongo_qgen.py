import os
import subprocess
import re

class MongoQGen:
    def __init__(self, target_folder, 
                queries_template_folder, tpch_dbgen):
        self.target = target_folder
        self.ddl = "queries"
        self.templates = queries_template_folder
        self.tpch_dbgen = tpch_dbgen

    def generate( self, query_number: int ):
        print("Generating Query {}".format(query_number))
        ddl_lines = self.get_clean_file(os.path.join( self.tpch_dbgen, self.ddl, str(query_number) + ".sql" ))
        sql_lines = self.get_sql_query(query_number)
        template = os.path.join( self.templates, str(query_number) + ".tpl" )
        target = os.path.join(self.target, str(query_number) + ".js")

        variables = self.get_variables(ddl_lines, sql_lines)
        mongo_query_lines = self.replace_variables_in_template(variables, template)
        if(self.save_query(mongo_query_lines, self.target, str(query_number) + ".js" )):
            print("Query " + target + " generated successfully")
        else:
            print("Error generating query " + target)

    def get_clean_file(self, filepath):
        lines = []
        with open(filepath) as f:
            lines = f.readlines()
            self.get_clean_lines(lines)
        return lines
    
    def get_clean_lines(self, lines):
        # Removing whites
        for i in range(len(lines)):
            lines[i] = lines[i].strip()

        # Ignoring Commentaries and position markers
        i = 0
        while( i < len(lines) ):
            if(lines[i] == '' or lines[i][0:2] == "--" or lines[i][0] == ':' ):
                del lines[i]
                continue
            i+=1
        return lines

    def get_sql_query(self, query_number):
        os.environ["DSS_QUERY"] = self.ddl
        command = [os.path.join(".", "qgen"), str(query_number)]
        proc = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=self.tpch_dbgen)
        o, e = proc.communicate()
        if proc.returncode == 0:
            lines = o.decode("ascii").splitlines()
            return self.get_clean_lines(lines)
        else:
            print("Error generating sql query")
            print(e)
        
    def get_variables(self, sql_template_lines, sql_lines) -> dict:
        assert(len(sql_lines) == len(sql_template_lines) + 1)
        sep = r'(:\d+)'
        variables = {}
        for line_number in range(len(sql_template_lines)):
            tpl_line = sql_template_lines[line_number]
            sql_line = sql_lines[line_number]
            partition = re.split(sep, tpl_line)
            regex = self.generate_regex_matcher(partition)
            values = re.match(regex, sql_line)
            if(not values): 
                print("Dont Match")
                print(regex, sql_line)
                print(re.match(regex, sql_line))
                continue
            values = values.groups()
            sep_apparitions = [ elem[1:] for elem in partition if re.match( sep, elem ) ]
            for key, value  in zip(sep_apparitions, values):
                variables[key] = value
        return variables



    def generate_regex_matcher(self, partition):
        regex = ""
        for atom in partition:
            if re.match(r":\d+", atom):
                regex += "(.*)"
            else:
                regex += re.escape(atom)

        return regex
    
    def replace_variables_in_template(self, variables, template_path):
        sep = r'(&\d+)'
        output_lines = []
        with open(template_path) as tpl:
            lines = tpl.readlines()
            for line in lines:
                partition = re.split(sep, line)
                for i in range(len(partition)):
                    if re.match(sep, partition[i]):
                        key = partition[i][1:]
                        partition[i] = variables[key]
                new_line = "".join(partition)
                print(new_line)
                output_lines.append(new_line)
        return output_lines
    
    def save_query(self, mongo_query_lines, target_folder, filename):
        try:
            if not os.path.exists(target_folder):
                os.makedirs(target_folder)
            target = os.path.join(target_folder, filename)
            with open(target, 'w+') as t:
                t.writelines(mongo_query_lines)
            return True
        except:
            return False