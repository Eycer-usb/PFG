import sys
import pandas as pd
import scipy.stats as stats
from tabulate import tabulate
import matplotlib.pyplot as plt

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

    
    

def analysis(filename):
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

    
    print("Starting Analysis to Mongo results...")
    mongo_results = apply_analysis(df[df['database_key'] == 'mongodb'])
    
    postgres_results.to_csv("postgres_results.csv", index=False)
    mongo_results.to_csv("mongo_results.csv", index=False)
    
    return df, postgres_results, mongo_results


def plot_queries_energy_comparation(optimization_key, database_key, results):
    values_client = []
    values_server = []
    filtered_results = results.loc[ \
                ((df['database_key'] == database_key) &\
                    (df['optimization_key'] == optimization_key) &\
                    (df['client_energy_consumed'] > 0) &\
                    (df['client_energy_consumed'] != 0) &\
                    (df['server_energy_consumed'] != 0) &\
                    (df['server_energy_consumed'] > 0)
                        )]
    key = [i for i in range(1,23)]
    for i in key:
        result_query = filtered_results.loc[filtered_results['query_key'] == i]
        values_client.append(result_query['client_energy_consumed'].mean() / 1000)
        values_server.append(result_query['server_energy_consumed'].mean() / 1000000)
    
    # Graficando ambos resultados en el mismo lienzo
    figure, axis = plt.subplots(1, 2, constrained_layout=True)
    figure.tight_layout(w_pad=5, h_pad=5)
    figure.subplots_adjust(top=0.8)
    figure.suptitle('{} database - Optimization {}'.format(database_key.capitalize(), optimization_key), y=0.98)
    axis[0].bar(key, values_client, color = 'b')
    axis[0].set_title('Client Energy Consumed')
    axis[0].set_xlabel('Query')
    axis[0].set_ylabel('Energy Consumed (mJ)')
    axis[0].set_ylim(0, 50)
    
    axis[1].bar(key, values_server, color = 'r')
    axis[1].set_title('Server Energy Consumed')
    axis[1].set_xlabel('Query')
    axis[1].set_ylabel('Energy Consumed (J)')
    
    plt.savefig('figures/{}-{}-queries_energy_comparation.png'.format(database_key, optimization_key))
    
    
        
        

def plot_mean_energy_by_optimization(database_key, results):
    values_client = []
    values_server = []
    colors = ['b', 'r', 'g', 'y']
    optimizations = get_optimizations(results)
    
    for optimization_key in optimizations:
        filtered_results = results.loc[ \
                ((df['database_key'] == database_key) &\
                    (df['optimization_key'] == optimization_key) &\
                    (df['client_energy_consumed'] > 0) &\
                    (df['client_energy_consumed'] != 0) &\
                    (df['server_energy_consumed'] != 0) &\
                    (df['server_energy_consumed'] > 0)
                        )]
        values_client.append(filtered_results['client_energy_consumed'].mean() / 1000)
        values_server.append(filtered_results["server_energy_consumed"].mean()/1000000)
    # Graficando ambos resultados en el mismo lienzo
    figure, axis = plt.subplots(1, 2, constrained_layout=True)
    figure.tight_layout(w_pad=5, h_pad=5)
    figure.subplots_adjust(top=0.8)
    figure.suptitle('{} database'.format(database_key.capitalize()), y=0.98)
    for i, optimization in enumerate(optimizations):
        axis[0].bar(optimization, values_client[i], color = colors[i], label = optimization)
        axis[1].bar(optimization, values_server[i], color = colors[i], label = optimization)
        
    axis[0].set_title('Client Energy Consumed')
    axis[0].set_xlabel('Optimization')
    axis[0].set_ylabel('Mean Energy Consumed (mJ)')
    axis[0].get_xaxis().set_visible(False)
    axis[0].legend()
    axis[0].set_ylim(0,50)
    
    axis[1].set_title('Server Energy Consumed')
    axis[1].set_xlabel('Optimization')
    axis[1].set_ylabel('Mean Energy Consumed (J)')
    axis[1].get_xaxis().set_visible(False)
    axis[1].legend()
    plt.savefig('figures/{}-means_energy_by_optimization.png'.format(database_key))
    
    
def plot_queries_time_comparation(optimization_key, database_key, results):
    values = []
    filtered_results = results.loc[ \
                ((df['database_key'] == database_key) &\
                    (df['optimization_key'] == optimization_key) &\
                    (df['execution_time'] > 0)
                )]
    
    key = [i for i in range(1,23)]
    for i in key:
        result_query = filtered_results.loc[filtered_results['query_key'] == i]
        values.append(result_query['execution_time'].mean() / 1000) #Seconds
    
    figure = plt.figure(constrained_layout=True)
    figure.tight_layout(w_pad=5, h_pad=5)
    figure.subplots_adjust(top=0.8)
    figure.suptitle('{} database - Optimization {}'.format(database_key.capitalize(), optimization_key), y=0.98)
    plt.bar(key, values, color = 'b')
    plt.title('Execution Time')
    plt.xlabel('Query')
    plt.ylabel('Time (Sec)')
    
    
    plt.savefig('figures/{}-{}-queries_time_comparation.png'.format(database_key, optimization_key))
    
    
    


def plot_mean_time_by_optimization(database_key, results):
    values = []
    colors = ['b', 'r', 'g', 'y']
    optimizations = get_optimizations(results)
    
    for optimization_key in optimizations:
        filtered_results = results.loc[ \
                ((df['database_key'] == database_key) &\
                    (df['optimization_key'] == optimization_key) &\
                    (df['execution_time'] > 0)
                        )]
        values.append(filtered_results['execution_time'].mean() / 1000)
        
    figure, axis = plt.subplots(1, 1, constrained_layout=True)
    figure.tight_layout(w_pad=5, h_pad=5)
    figure.subplots_adjust(top=0.8)
    figure.suptitle('{} database'.format(database_key.capitalize()), y=0.98)
    for i, optimization in enumerate(optimizations):
        axis.bar(optimization, values[i], color = colors[i], label = optimization)
        
    axis.set_title('Execution Time')
    axis.set_xlabel('Optimization')
    axis.set_ylabel('Mean Execution Time (Sec)')
    axis.get_xaxis().set_visible(False)
    axis.legend()
    
    plt.savefig('figures/{}-means_time_by_optimization.png'.format(database_key))


def plots(results, postgres_analysis, mongo_analysis):
    print("Generating plots...")
    optimizations = get_optimizations(df)
    # Energy
    for optimization_key in optimizations:
        plot_queries_energy_comparation(optimization_key, "postgres", results)
        
    for optimization_key in optimizations:
            plot_queries_energy_comparation(optimization_key, "mongodb", results)
            

    plot_mean_energy_by_optimization("postgres", results)
    plot_mean_energy_by_optimization("mongodb", results)

    # Execution Time
    for optimization_key in optimizations:
        plot_queries_time_comparation(optimization_key, "postgres", results)
        
    for optimization_key in optimizations:
            plot_queries_time_comparation(optimization_key, "mongodb", results)
            
    plot_mean_time_by_optimization("postgres", results)
    plot_mean_time_by_optimization("mongodb", results)


if "__main__" == __name__:
    file_name = sys.argv[1]
    df, postgres_results, mongo_results = analysis(file_name)
    plots(df, postgres_results, mongo_results)