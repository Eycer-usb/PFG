import sys
import pandas as pd
import scipy.stats as stats


def get_optimizations(df):
    return df['optimization_key'].unique()

def wilcoxon(column_name, df1, df2):
    group1 = list(df1[column_name])
    group2 = list(df2[column_name])
    lenght = min(len(group1), len(group2))
    return stats.wilcoxon(group1[0:lenght], group2[0:lenght])

def apply_analysis(df):
    header = [ "{}-{}-{}".format(optimization, metric, stat) for optimization in get_optimizations(df) for metric in ['client_energy_consumed', 'server_energy_consumed'] for stat in ['mean', 'std', 'wilcoxon_p-value']]
    result = pd.DataFrame(columns= header)
    for query in range(1,23):
        row = []
        for optimization in get_optimizations(df):
            query_optimization_result = df.loc[ \
                ((df['optimization_key'] == optimization) &\
                (df['query_key'] == query) &\
                (df['client_energy_consumed'] > 0) &\
                (df['client_energy_consumed'] != 0) &\
                (df['server_energy_consumed'] != 0) &\
                (df['server_energy_consumed'] > 0)
                    )]
            query_optimization_result = query_optimization_result[['execution_time', 'client_energy_consumed', 'server_energy_consumed']]
            means = query_optimization_result.mean( skipna = True )
            stds = query_optimization_result.std( ddof=0 )
            
            g1 = query_optimization_result
            base = df.loc[ \
                ((df['query_key'] == query) &\
                    (df['optimization_key'] == 'base') &\
                    (df['client_energy_consumed'] > 0) &\
                    (df['client_energy_consumed'] != 0) &\
                    (df['server_energy_consumed'] != 0) &\
                    (df['server_energy_consumed'] > 0)
                        )]
            if(optimization != "base"):
                wilcoxons = [
                    wilcoxon( var, g1, base ) for var in ['client_energy_consumed', 'server_energy_consumed']
                ]
                row = row + [means['client_energy_consumed'], stds['client_energy_consumed'], 
                         wilcoxons[0].pvalue, means['server_energy_consumed'], stds['server_energy_consumed'], wilcoxons[1].pvalue]
            else:
                wilcoxons = ["N/A", "N/A"]
                row = row + [means['client_energy_consumed'], stds['client_energy_consumed'], 
                         wilcoxons[0], means['server_energy_consumed'], stds['server_energy_consumed'], wilcoxons[1]]
            
        result.loc[len(result)] = row
    return result
            
        


def make_plots(df):
    pass

def main(filename):
    df = pd.read_csv(filename, dtype={
    "id": "int64",
    "database_key": "string",
    "optimization_key": "string",
    "query_key": "int64",
    "iteration": "int64",
    "start_time": "string",
    "end_time": "string",
    "execution_time": "int64",
    "client_energy_consumed": "float64",
    "server_energy_consumed": "float64"
})
    print("Starting Analysis to Postgres results...")
    postgres_results = apply_analysis(df[df['database_key'] == 'postgres'])

    postgres_results.to_csv("postgres_results.csv", index=False)
    
    
    print("Starting Analysis to Mongo results...")
    mongo_results = apply_analysis(df[df['database_key'] == 'mongodb'])
    postgres_results.to_csv("mongo_results.csv", index=False)

    

if "__main__" == __name__:
    file_name = sys.argv[1]
    main(file_name)