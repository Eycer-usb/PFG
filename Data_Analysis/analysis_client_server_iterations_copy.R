#### Q1 ####
# Base Q1
dataBase_Q01 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                        "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q01' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q01)

mQ1_client_base <- mean(dataBase_Q01$Juliet_Client_Total_Energy)
mQ1_client_base # 25.27985
sdQ01_client_base <- sd(dataBase_Q01$Juliet_Client_Total_Energy)
sdQ01_client_base # 3.16822
sdQ01_client_base / mQ1_client_base # 0.1253259

mQ1_server_base <- mean(dataBase_Q01$Server_Total_Energy)
mQ1_server_base # 320.2622
sdQ01_server_base <- sd(dataBase_Q01$Server_Total_Energy)
sdQ01_server_base # 11.1036
sdQ01_server_base / mQ1_server_base # 0.03467033

# Index Q1
dataIndex_Q01 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q01' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q01)

mQ1_client_index <- mean(dataIndex_Q01$Juliet_Client_Total_Energy)
mQ1_client_index # 22.33778
sdQ01_client_index <- sd(dataIndex_Q01$Juliet_Client_Total_Energy)
sdQ01_client_index # 2.345669
sdQ01_client_index / mQ1_client_index # 0.105009

mQ1_server_index <- mean(dataIndex_Q01$Server_Total_Energy)
mQ1_server_index # 139.6515
sdQ01_server_index <- sd(dataIndex_Q01$Server_Total_Energy)
sdQ01_server_index # 9.422473
sdQ01_server_index / mQ1_server_index # 0.06747132

wilcox.test(dataIndex_Q01$Juliet_Client_Total_Energy, dataBase_Q01$Juliet_Client_Total_Energy) # W = 200, p-value = 0.0001433
wilcox.test(dataIndex_Q01$Server_Total_Energy, dataBase_Q01$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIndex_Q01$Total_Energy, dataBase_Q01$Total_Energy) # W = 0, p-value < 2.2e-16

x1_client_index <- (mQ1_client_index / mQ1_client_base) * 100
100 - x1_client_index # 11.63799

x1_server_index <- (mQ1_server_index / mQ1_server_base) * 100
100 - x1_server_index # 56.39463

# Compression Q1
dataCompression_Q01 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q01' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q01)

mQ1_client_cmp <- mean(dataCompression_Q01$Juliet_Client_Total_Energy)
mQ1_client_cmp # 24.04153
sdQ01_client_cmp <- sd(dataCompression_Q01$Juliet_Client_Total_Energy)
sdQ01_client_cmp # 1.644323
sdQ01_client_cmp / mQ1_client_cmp # 0.06839511

mQ1_server_cmp <- mean(dataCompression_Q01$Server_Total_Energy)
mQ1_server_cmp # 318.3599
sdQ01_server_cmp <- sd(dataCompression_Q01$Server_Total_Energy)
sdQ01_server_cmp # 6.0113
sdQ01_server_cmp / mQ1_server_cmp # 0.01888209

wilcox.test(dataCompression_Q01$Juliet_Client_Total_Energy, dataBase_Q01$Juliet_Client_Total_Energy) # W = 344, p-value = 0.1194
wilcox.test(dataCompression_Q01$Server_Total_Energy, dataBase_Q01$Server_Total_Energy) # W = 454, p-value = 0.959
wilcox.test(dataCompression_Q01$Total_Energy, dataBase_Q01$Total_Energy) # W = 424, p-value = 0.7082

# Index-Compression Q1
dataIC_Q01 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q01' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q01)

mQ1_client_IC <- mean(dataIC_Q01$Juliet_Client_Total_Energy)
mQ1_client_IC # 22.742
sdQ01_client_IC <- sd(dataIC_Q01$Juliet_Client_Total_Energy)
sdQ01_client_IC # 1.87866
sdQ01_client_IC / mQ1_client_IC # 0.08260751

mQ1_server_IC <- mean(dataIC_Q01$Server_Total_Energy)
mQ1_server_IC # 135.744
sdQ01_server_IC <- sd(dataIC_Q01$Server_Total_Energy)
sdQ01_server_IC # 6.533752
sdQ01_server_IC / mQ1_server_IC # 0.0481329

wilcox.test(dataIC_Q01$Juliet_Client_Total_Energy, dataBase_Q01$Juliet_Client_Total_Energy) # W = 213, p-value = 0.0003322
wilcox.test(dataIC_Q01$Server_Total_Energy, dataBase_Q01$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIC_Q01$Total_Energy, dataBase_Q01$Total_Energy) # W = 0, p-value < 2.2e-16

x1_client_IC <- (mQ1_client_IC / mQ1_client_base) * 100
100 - x1_client_IC # 10.03901

x1_server_IC <- (mQ1_server_IC / mQ1_server_base) * 100
100 - x1_server_IC # 57.61473

#### Q2 ####
# Base Q2
dataBase_Q02 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q02' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q02)

mQ2_client_base <- mean(dataBase_Q02$Juliet_Client_Total_Energy)
mQ2_client_base # 19.70772
sdQ2_client_base <- sd(dataBase_Q02$Juliet_Client_Total_Energy)
sdQ2_client_base # 4.441862
sdQ2_client_base / mQ2_client_base # 0.2253869

mQ2_server_base <- mean(dataBase_Q02$Server_Total_Energy)
mQ2_server_base # 1.842695
sdQ2_server_base <- sd(dataBase_Q02$Server_Total_Energy)
sdQ2_server_base # 0.8275819
sdQ2_server_base / mQ2_server_base # 0.449115

# Index Q2
dataIndex_Q02 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q02' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q02)

mQ2_client_index <- mean(dataIndex_Q02$Juliet_Client_Total_Energy)
mQ2_client_index # 16.45851
sdQ2_client_index <- sd(dataIndex_Q02$Juliet_Client_Total_Energy)
sdQ2_client_index # 1.891212
sdQ2_client_index / mQ2_client_index # 0.1149078

mQ2_server_index <- mean(dataIndex_Q02$Server_Total_Energy)
mQ2_server_index # 7.619242
sdQ2_server_index <- sd(dataIndex_Q02$Server_Total_Energy)
sdQ2_server_index # 0.7811094
sdQ2_server_index / mQ2_server_index # 0.102518

wilcox.test(dataIndex_Q02$Juliet_Client_Total_Energy, dataBase_Q02$Juliet_Client_Total_Energy) # W = 242, p-value = 0.001795
wilcox.test(dataIndex_Q02$Server_Total_Energy, dataBase_Q02$Server_Total_Energy) # W = 900, p-value < 2.2e-16
wilcox.test(dataIndex_Q02$Total_Energy, dataBase_Q02$Total_Energy) # W = 649, p-value = 0.002883

x2_client_index <- (mQ2_client_index / mQ2_client_base) * 100
100 - x2_client_index # 16.48699

x2_server_index <- (mQ2_server_index / mQ2_server_base) * 100
100 - x2_server_index # -313.4836

# Compression Q2
dataCompression_Q02 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q02' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q02)

mQ2_client_cmp <- mean(dataCompression_Q02$Juliet_Client_Total_Energy)
mQ2_client_cmp # 18.39352
sdQ2_client_cmp <- sd(dataCompression_Q02$Juliet_Client_Total_Energy)
sdQ2_client_cmp # 2.167081
sdQ2_client_cmp / mQ2_client_cmp # 0.1178176

mQ2_server_cmp <- mean(dataCompression_Q02$Server_Total_Energy)
mQ2_server_cmp # 8.384071
sdQ2_server_cmp <- sd(dataCompression_Q02$Server_Total_Energy)
sdQ2_server_cmp # 0.9602046
sdQ2_server_cmp / mQ2_server_cmp # 0.1145273

wilcox.test(dataCompression_Q02$Juliet_Client_Total_Energy, dataBase_Q02$Juliet_Client_Total_Energy) # W = 423, p-value = 0.6973
wilcox.test(dataCompression_Q02$Server_Total_Energy, dataBase_Q02$Server_Total_Energy) # W = 900, p-value < 2.2e-16
wilcox.test(dataCompression_Q02$Total_Energy, dataBase_Q02$Total_Energy) # W = 731, p-value = 1.517e-05

x2_client_cmp <- (mQ2_client_cmp / mQ2_client_base) * 100
100 - x2_client_cmp # 6.668452

x2_server_cmp <- (mQ2_server_cmp / mQ2_server_base) * 100
100 - x2_server_cmp # -354.9896

# Index-Compression Q2
dataIC_Q02 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q02' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q02)

mQ2_client_IC <- mean(dataIC_Q02$Juliet_Client_Total_Energy)
mQ2_client_IC # 18.16879
sdQ2_client_IC <- sd(dataIC_Q02$Juliet_Client_Total_Energy)
sdQ2_client_IC # 1.757685
sdQ2_client_IC / mQ2_client_IC # 0.09674198

mQ2_server_IC <- mean(dataIC_Q02$Server_Total_Energy)
mQ2_server_IC # 7.490859
sdQ2_server_IC <- sd(dataIC_Q02$Server_Total_Energy)
sdQ2_server_IC # 0.8206208
sdQ2_server_IC / mQ2_server_IC # 0.1095496

wilcox.test(dataIC_Q02$Juliet_Client_Total_Energy, dataBase_Q02$Juliet_Client_Total_Energy) # W = 437, p-value = 0.8545
wilcox.test(dataIC_Q02$Server_Total_Energy, dataBase_Q02$Server_Total_Energy) # W = 900, p-value < 2.2e-16
wilcox.test(dataIC_Q02$Total_Energy, dataBase_Q02$Total_Energy) # W = 698, p-value = 0.0001636

x2_client_IC <- (mQ2_client_IC / mQ2_client_base) * 100
100 - x2_client_IC # 7.808783

x2_server_IC <- (mQ2_server_IC / mQ2_server_base) * 100
100 - x2_server_IC # -306.5165

#### Q3 ####
# Base Q3
dataBase_Q03 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q03' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q03)

mQ3_client_base <- mean(dataBase_Q03$Juliet_Client_Total_Energy)
mQ3_client_base # 22.09365
sdQ3_client_base <- sd(dataBase_Q03$Juliet_Client_Total_Energy)
sdQ3_client_base # 2.986695
sdQ3_client_base / mQ3_client_base # 0.1351834

mQ3_server_base <- mean(dataBase_Q03$Server_Total_Energy)
mQ3_server_base # 60.22048
sdQ3_server_base <- sd(dataBase_Q03$Server_Total_Energy)
sdQ3_server_base # 4.17996
sdQ3_server_base / mQ3_server_base # 0.06941094

# Index Q3
dataIndex_Q03 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q03' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q03)

mQ3_client_index <- mean(dataIndex_Q03$Juliet_Client_Total_Energy)
mQ3_client_index # 19.50076
sdQ3_client_index <- sd(dataIndex_Q03$Juliet_Client_Total_Energy)
sdQ3_client_index # 1.759799
sdQ3_client_index / mQ3_client_index # 0.09024259

mQ3_server_index <- mean(dataIndex_Q03$Server_Total_Energy)
mQ3_server_index # 57.52425
sdQ3_server_index <- sd(dataIndex_Q03$Server_Total_Energy)
sdQ3_server_index # 2.336146
sdQ3_server_index / mQ3_server_index # 0.0406115

wilcox.test(dataIndex_Q03$Juliet_Client_Total_Energy, dataBase_Q03$Juliet_Client_Total_Energy) # W = 232, p-value = 0.001032
wilcox.test(dataIndex_Q03$Server_Total_Energy, dataBase_Q03$Server_Total_Energy) # W = 251, p-value = 0.002883
wilcox.test(dataIndex_Q03$Total_Energy, dataBase_Q03$Total_Energy) # W = 198, p-value = 0.0001252

x3_client_index <- (mQ3_client_index / mQ3_client_base) * 100
100 - x3_client_index # 11.73592

x3_server_index <- (mQ3_server_index / mQ3_server_base) * 100
100 - x3_server_index # 4.477253

# Compression Q3
dataCompression_Q03 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q03' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q03)

mQ3_client_cmp <- mean(dataCompression_Q03$Juliet_Client_Total_Energy)
mQ3_client_cmp # 19.7959
sdQ3_client_cmp <- sd(dataCompression_Q03$Juliet_Client_Total_Energy)
sdQ3_client_cmp # 2.168457
sdQ3_client_cmp / mQ3_client_cmp # 0.1095407

mQ3_server_cmp <- mean(dataCompression_Q03$Server_Total_Energy)
mQ3_server_cmp # 53.62157
sdQ3_server_cmp <- sd(dataCompression_Q03$Server_Total_Energy)
sdQ3_server_cmp # 2.178921
sdQ3_server_cmp / mQ3_server_cmp # 0.04063516

wilcox.test(dataCompression_Q03$Juliet_Client_Total_Energy, dataBase_Q03$Juliet_Client_Total_Energy) # W = 269, p-value = 0.006969
wilcox.test(dataCompression_Q03$Server_Total_Energy, dataBase_Q03$Server_Total_Energy) # W = 18, p-value = 2.701e-14
wilcox.test(dataCompression_Q03$Total_Energy, dataBase_Q03$Total_Energy) # W = 73, p-value = 7.243e-10

x3_client_cmp <- (mQ3_client_cmp / mQ3_client_base) * 100
100 - x3_client_cmp # 10.40006

x3_server_cmp <- (mQ3_server_cmp / mQ3_server_base) * 100
100 - x3_server_cmp # 10.95792

# Index-Compression Q3
dataIC_Q03 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q03' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q03)

mQ3_client_IC <- mean(dataIC_Q03$Juliet_Client_Total_Energy)
mQ3_client_IC # 18.56984
sdQ3_client_IC <- sd(dataIC_Q03$Juliet_Client_Total_Energy)
sdQ3_client_IC # 1.525606
sdQ3_client_IC / mQ3_client_IC # 0.08215504

mQ3_server_IC <- mean(dataIC_Q03$Server_Total_Energy)
mQ3_server_IC # 54.48971
sdQ3_server_IC <- sd(dataIC_Q03$Server_Total_Energy)
sdQ3_server_IC # 2.565939
sdQ3_server_IC / mQ3_server_IC # 0.04709034

wilcox.test(dataIC_Q03$Juliet_Client_Total_Energy, dataBase_Q03$Juliet_Client_Total_Energy) # W = 132, p-value = 6.198e-07
wilcox.test(dataIC_Q03$Server_Total_Energy, dataBase_Q03$Server_Total_Energy) # W = 70, p-value = 4.757e-10
wilcox.test(dataIC_Q03$Total_Energy, dataBase_Q03$Total_Energy) # W = 58, p-value = 7.957e-11

x3_client_IC <- (mQ3_client_IC / mQ3_client_base) * 100
100 - x3_client_IC # 15.94941

x3_server_IC <- (mQ3_server_IC / mQ3_server_base) * 100
100 - x3_server_IC # 9.516304

#### Q4 ####
# Base Q4
dataBase_Q04 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q04' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q04)

mQ4_client_base <- mean(dataBase_Q04$Juliet_Client_Total_Energy)
mQ4_client_base # 19.85422
sdQ4_client_base <- sd(dataBase_Q04$Juliet_Client_Total_Energy)
sdQ4_client_base # 3.732555
sdQ4_client_base / mQ4_client_base # 0.187998

mQ4_server_base <- mean(dataBase_Q04$Server_Total_Energy)
mQ4_server_base # 26.6413
sdQ4_server_base <- sd(dataBase_Q04$Server_Total_Energy)
sdQ4_server_base # 78.16782
sdQ4_server_base / mQ4_server_base # 2.934084

# Index Q4
dataIndex_Q04 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q04' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q04)

mQ4_client_index <- mean(dataIndex_Q04$Juliet_Client_Total_Energy)
mQ4_client_index # 17.97067
sdQ4_client_index <- sd(dataIndex_Q04$Juliet_Client_Total_Energy)
sdQ4_client_index # 3.937977
sdQ4_client_index / mQ4_client_index # 0.2191336

mQ4_server_index <- mean(dataIndex_Q04$Server_Total_Energy)
mQ4_server_index # 38.81713
sdQ4_server_index <- sd(dataIndex_Q04$Server_Total_Energy)
sdQ4_server_index # 92.94838
sdQ4_server_index / mQ4_server_index # 2.39452

wilcox.test(dataIndex_Q04$Juliet_Client_Total_Energy, dataBase_Q04$Juliet_Client_Total_Energy) # W = 224, p-value = 0.0006489
wilcox.test(dataIndex_Q04$Server_Total_Energy, dataBase_Q04$Server_Total_Energy) # W = 115, p-value = 1.132e-07
wilcox.test(dataIndex_Q04$Total_Energy, dataBase_Q04$Total_Energy) # W = 137, p-value = 9.917e-07

x4_client_index <- (mQ4_client_index / mQ4_client_base) * 100
100 - x4_client_index # 11.73592

x4_server_index <- (mQ4_server_index / mQ4_server_base) * 100
100 - x4_server_index # 4.477253

# Compression Q4
dataCompression_Q04 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q04' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q04)

mQ4_client_cmp <- mean(dataCompression_Q04$Juliet_Client_Total_Energy)
mQ4_client_cmp # 17.15513
sdQ4_client_cmp <- sd(dataCompression_Q04$Juliet_Client_Total_Energy)
sdQ4_client_cmp # 3.706851
sdQ4_client_cmp / mQ4_client_cmp # 0.2160783

mQ4_server_cmp <- mean(dataCompression_Q04$Server_Total_Energy)
mQ4_server_cmp # 22.15487
sdQ4_server_cmp <- sd(dataCompression_Q04$Server_Total_Energy)
sdQ4_server_cmp # 68.35027
sdQ4_server_cmp / mQ4_server_cmp # 3.085113

wilcox.test(dataCompression_Q04$Juliet_Client_Total_Energy, dataBase_Q04$Juliet_Client_Total_Energy) # W = 155, p-value = 4.867e-06
wilcox.test(dataCompression_Q04$Server_Total_Energy, dataBase_Q04$Server_Total_Energy) # W = 204, p-value = 0.0001867
wilcox.test(dataCompression_Q04$Total_Energy, dataBase_Q04$Total_Energy) # W = 114, p-value = 1.018e-07

x4_client_cmp <- (mQ4_client_cmp / mQ4_client_base) * 100
100 - x4_client_cmp # 10.40006

x4_server_cmp <- (mQ4_server_cmp / mQ4_server_base) * 100
100 - x4_server_cmp # 10.95792

# Index-Compression Q4
dataIC_Q04 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q04' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q04)

mQ4_client_IC <- mean(dataIC_Q04$Juliet_Client_Total_Energy)
mQ4_client_IC # 17.51398
sdQ4_client_IC <- sd(dataIC_Q04$Juliet_Client_Total_Energy)
sdQ4_client_IC # 3.753134
sdQ4_client_IC / mQ4_client_IC # 0.2142936

mQ4_server_IC <- mean(dataIC_Q04$Server_Total_Energy)
mQ4_server_IC # 29.19761
sdQ4_server_IC <- sd(dataIC_Q04$Server_Total_Energy)
sdQ4_server_IC # 80.74771
sdQ4_server_IC / mQ4_server_IC # 2.765559

wilcox.test(dataIC_Q04$Juliet_Client_Total_Energy, dataBase_Q04$Juliet_Client_Total_Energy) # W = 132, p-value = 6.198e-07
wilcox.test(dataIC_Q04$Server_Total_Energy, dataBase_Q04$Server_Total_Energy) # W = 70, p-value = 4.757e-10
wilcox.test(dataIC_Q04$Total_Energy, dataBase_Q04$Total_Energy) # W = 58, p-value = 7.957e-11

x4_client_IC <- (mQ4_client_IC / mQ4_client_base) * 100
100 - x4_client_IC # 15.94941

x4_server_IC <- (mQ4_server_IC / mQ4_server_base) * 100
100 - x4_server_IC # 9.516304

#### Q4 BIS #### deleting 4 first rows
# Base Q4
dataBase_Q04 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Iteration > 4 and Query = 'Q04' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q04)

mQ4_client_base <- mean(dataBase_Q04$Juliet_Client_Total_Energy)
mQ4_client_base # 18.94959
sdQ4_client_base <- sd(dataBase_Q04$Juliet_Client_Total_Energy)
sdQ4_client_base # 1.749722
sdQ4_client_base / mQ4_client_base # 0.09233558

mQ4_server_base <- mean(dataBase_Q04$Server_Total_Energy)
mQ4_server_base # 6.14943
sdQ4_server_base <- sd(dataBase_Q04$Server_Total_Energy)
sdQ4_server_base # 1.507564
sdQ4_server_base / mQ4_server_base # 0.2451551

# Index Q4
dataIndex_Q04 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Iteration > 4 and Query = 'Q04' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q04)

mQ4_client_index <- mean(dataIndex_Q04$Juliet_Client_Total_Energy)
mQ4_client_index # 16.6162
sdQ4_client_index <- sd(dataIndex_Q04$Juliet_Client_Total_Energy)
sdQ4_client_index # 1.712331
sdQ4_client_index / mQ4_client_index # 0.1030519

mQ4_server_index <- mean(dataIndex_Q04$Server_Total_Energy)
mQ4_server_index # 2.998993
sdQ4_server_index <- sd(dataIndex_Q04$Server_Total_Energy)
sdQ4_server_index # 0.5667696
sdQ4_server_index / mQ4_server_index # 0.1889866

wilcox.test(dataIndex_Q04$Juliet_Client_Total_Energy, dataBase_Q04$Juliet_Client_Total_Energy) # W = 109, p-value = 1.065e-05
wilcox.test(dataIndex_Q04$Server_Total_Energy, dataBase_Q04$Server_Total_Energy) # W = 2, p-value = 1.613e-14
wilcox.test(dataIndex_Q04$Total_Energy, dataBase_Q04$Total_Energy) # W = 24, p-value = 2.959e-11

x4_client_index <- (mQ4_client_index / mQ4_client_base) * 100
100 - x4_client_index # 12.31368

x4_server_index <- (mQ4_server_index / mQ4_server_base) * 100
100 - x4_server_index # 51.23137

# Compression Q4
dataCompression_Q04 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Iteration > 4 and Query = 'Q04' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q04)

mQ4_client_cmp <- mean(dataCompression_Q04$Juliet_Client_Total_Energy)
mQ4_client_cmp # 16.34232
sdQ4_client_cmp <- sd(dataCompression_Q04$Juliet_Client_Total_Energy)
sdQ4_client_cmp # 1.686088
sdQ4_client_cmp / mQ4_client_cmp # 0.1031731

mQ4_server_cmp <- mean(dataCompression_Q04$Server_Total_Energy)
mQ4_server_cmp # 4.248565
sdQ4_server_cmp <- sd(dataCompression_Q04$Server_Total_Energy)
sdQ4_server_cmp # 1.223529
sdQ4_server_cmp / mQ4_server_cmp # 0.2879863

wilcox.test(dataCompression_Q04$Juliet_Client_Total_Energy, dataBase_Q04$Juliet_Client_Total_Energy) # W = 96, p-value = 2.644e-06
wilcox.test(dataCompression_Q04$Server_Total_Energy, dataBase_Q04$Server_Total_Energy) # W = 125, p-value = 5.008e-05
wilcox.test(dataCompression_Q04$Total_Energy, dataBase_Q04$Total_Energy) # W = 55, p-value = 1.134e-08

x4_client_cmp <- (mQ4_client_cmp / mQ4_client_base) * 100
100 - x4_client_cmp # 13.75897

x4_server_cmp <- (mQ4_server_cmp / mQ4_server_base) * 100
100 - x4_server_cmp # 30.91124

# Index-Compression Q4
dataIC_Q04 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Iteration > 4 and Query = 'Q04' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q04)

mQ4_client_IC <- mean(dataIC_Q04$Juliet_Client_Total_Energy)
mQ4_client_IC # 16.44278
sdQ4_client_IC <- sd(dataIC_Q04$Juliet_Client_Total_Energy)
sdQ4_client_IC # 1.33358
sdQ4_client_IC / mQ4_client_IC # 0.08110426

mQ4_server_IC <- mean(dataIC_Q04$Server_Total_Energy)
mQ4_server_IC # 2.763507
sdQ4_server_IC <- sd(dataIC_Q04$Server_Total_Energy)
sdQ4_server_IC # 0.6124328
sdQ4_server_IC / mQ4_server_IC # 0.2216144

wilcox.test(dataIC_Q04$Juliet_Client_Total_Energy, dataBase_Q04$Juliet_Client_Total_Energy) # W = 76, p-value = 2.335e-07
wilcox.test(dataIC_Q04$Server_Total_Energy, dataBase_Q04$Server_Total_Energy) # W = 2, p-value = 1.613e-14
wilcox.test(dataIC_Q04$Total_Energy, dataBase_Q04$Total_Energy) # W = 19, p-value = 8.417e-12

x4_client_IC <- (mQ4_client_IC / mQ4_client_base) * 100
100 - x4_client_IC # 13.22884

x4_server_IC <- (mQ4_server_IC / mQ4_server_base) * 100
100 - x4_server_IC # 55.06077

#### Q5 ####
# Base Q5
dataBase_Q05 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q05' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q05)

mQ5_client_base <- mean(dataBase_Q05$Juliet_Client_Total_Energy)
mQ5_client_base # 18.78261
sdQ5_client_base <- sd(dataBase_Q05$Juliet_Client_Total_Energy)
sdQ5_client_base # 2.375966
sdQ5_client_base / mQ5_client_base # 0.1264982

mQ5_server_base <- mean(dataBase_Q05$Server_Total_Energy)
mQ5_server_base # 21.4277
sdQ5_server_base <- sd(dataBase_Q05$Server_Total_Energy)
sdQ5_server_base # 1.286165
sdQ5_server_base / mQ5_server_base # 0.06002346

# Index Q5
dataIndex_Q05 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q05' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q05)

mQ5_client_index <- mean(dataIndex_Q05$Juliet_Client_Total_Energy)
mQ5_client_index # 18.32499
sdQ5_client_index <- sd(dataIndex_Q05$Juliet_Client_Total_Energy)
sdQ5_client_index # 2.019338
sdQ5_client_index / mQ5_client_index # 0.1101959

mQ5_server_index <- mean(dataIndex_Q05$Server_Total_Energy)
mQ5_server_index # 26.5027
sdQ5_server_index <- sd(dataIndex_Q05$Server_Total_Energy)
sdQ5_server_index # 1.805081
sdQ5_server_index / mQ5_server_index # 0.06810935

wilcox.test(dataIndex_Q05$Juliet_Client_Total_Energy, dataBase_Q05$Juliet_Client_Total_Energy) # W = 387, p-value = 0.3581
wilcox.test(dataIndex_Q05$Server_Total_Energy, dataBase_Q05$Server_Total_Energy) # W = 892, p-value = 1.133e-15
wilcox.test(dataIndex_Q05$Total_Energy, dataBase_Q05$Total_Energy) # W = 803, p-value = 1.537e-08

x5_client_index <- (mQ5_client_index / mQ5_client_base) * 100
100 - x5_client_index # 2.436438

x5_server_index <- (mQ5_server_index / mQ5_server_base) * 100
100 - x5_server_index # -23.68426


# Compression Q5
dataCompression_Q05 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q05' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q05)

mQ5_client_cmp <- mean(dataCompression_Q05$Juliet_Client_Total_Energy)
mQ5_client_cmp # 18.1212
sdQ5_client_cmp <- sd(dataCompression_Q05$Juliet_Client_Total_Energy)
sdQ5_client_cmp # 2.134579
sdQ5_client_cmp / mQ5_client_cmp # 0.1177946

mQ5_server_cmp <- mean(dataCompression_Q05$Server_Total_Energy)
mQ5_server_cmp # 18.18425
sdQ5_server_cmp <- sd(dataCompression_Q05$Server_Total_Energy)
sdQ5_server_cmp # 1.806309
sdQ5_server_cmp / mQ5_server_cmp # 0.09933371

wilcox.test(dataCompression_Q05$Juliet_Client_Total_Energy, dataBase_Q05$Juliet_Client_Total_Energy) # W = 387, p-value = 0.3581
wilcox.test(dataCompression_Q05$Server_Total_Energy, dataBase_Q05$Server_Total_Energy) # W = 53, p-value = 3.567e-11
wilcox.test(dataCompression_Q05$Total_Energy, dataBase_Q05$Total_Energy) # W = 193, p-value = 8.896e-05

x5_client_cmp <- (mQ5_client_cmp / mQ5_client_base) * 100
100 - x5_client_cmp # 3.521413

x5_server_cmp <- (mQ5_server_cmp / mQ5_server_base) * 100
100 - x5_server_cmp # 15.13673

# Index-Compression Q5
dataIC_Q05 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q05' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q05)

mQ5_client_IC <- mean(dataIC_Q05$Juliet_Client_Total_Energy)
mQ5_client_IC # 19.1439
sdQ5_client_IC <- sd(dataIC_Q05$Juliet_Client_Total_Energy)
sdQ5_client_IC # 2.072357
sdQ5_client_IC / mQ5_client_IC # 0.1082516

mQ5_server_IC <- mean(dataIC_Q05$Server_Total_Energy)
mQ5_server_IC # 25.0367
sdQ5_server_IC <- sd(dataIC_Q05$Server_Total_Energy)
sdQ5_server_IC # 2.135579
sdQ5_server_IC / mQ5_server_IC # 0.08529795

wilcox.test(dataIC_Q05$Juliet_Client_Total_Energy, dataBase_Q05$Juliet_Client_Total_Energy) # W = 486, p-value = 0.6022
wilcox.test(dataIC_Q05$Server_Total_Energy, dataBase_Q05$Server_Total_Energy) # W = 860, p-value = 3.632e-12
wilcox.test(dataIC_Q05$Total_Energy, dataBase_Q05$Total_Energy) # W = 754, p-value = 2.239e-06

x5_client_IC <- (mQ5_client_IC / mQ5_client_base) * 100
100 - x5_client_IC # -1.923499

x5_server_IC <- (mQ5_server_IC / mQ5_server_base) * 100
100 - x5_server_IC # -16.84268

#### Q6 ####
# Base Q6
dataBase_Q06 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q06' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q06)

mQ6_client_base <- mean(dataBase_Q06$Juliet_Client_Total_Energy)
mQ6_client_base # 19.58058
sdQ6_client_base <- sd(dataBase_Q06$Juliet_Client_Total_Energy)
sdQ6_client_base # 1.783535
sdQ6_client_base / mQ6_client_base # 0.09108693

mQ6_server_base <- mean(dataBase_Q06$Server_Total_Energy)
mQ6_server_base # 35.489
sdQ6_server_base <- sd(dataBase_Q06$Server_Total_Energy)
sdQ6_server_base # 1.65465
sdQ6_server_base / mQ6_server_base # 0.0466243

# Index Q6
dataIndex_Q06 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q06' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q06)

mQ6_client_index <- mean(dataIndex_Q06$Juliet_Client_Total_Energy)
mQ6_client_index # 18.93985
sdQ6_client_index <- sd(dataIndex_Q06$Juliet_Client_Total_Energy)
sdQ6_client_index # 2.03422
sdQ6_client_index / mQ6_client_index # 0.1074042

mQ6_server_index <- mean(dataIndex_Q06$Server_Total_Energy)
mQ6_server_index # 34.7256
sdQ6_server_index <- sd(dataIndex_Q06$Server_Total_Energy)
sdQ6_server_index # 1.9284
sdQ6_server_index / mQ6_server_index # 0.05553251

wilcox.test(dataIndex_Q06$Juliet_Client_Total_Energy, dataBase_Q06$Juliet_Client_Total_Energy) # W = 342, p-value = 0.1124
wilcox.test(dataIndex_Q06$Server_Total_Energy, dataBase_Q06$Server_Total_Energy) # W = 347, p-value = 0.1304
wilcox.test(dataIndex_Q06$Total_Energy, dataBase_Q06$Total_Energy) # W = 301, p-value = 0.02738

x6_client_index <- (mQ6_client_index / mQ6_client_base) * 100
100 - x6_client_index # 3.272256

x6_server_index <- (mQ6_server_index / mQ6_server_base) * 100
100 - x6_server_index # 2.151089

# Compression Q6
dataCompression_Q06 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q06' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q06)

mQ6_client_cmp <- mean(dataCompression_Q06$Juliet_Client_Total_Energy)
mQ6_client_cmp # 18.30521
sdQ6_client_cmp <- sd(dataCompression_Q06$Juliet_Client_Total_Energy)
sdQ6_client_cmp # 1.560529
sdQ6_client_cmp / mQ6_client_cmp # 0.08525055

mQ6_server_cmp <- mean(dataCompression_Q06$Server_Total_Energy)
mQ6_server_cmp # 33.61516
sdQ6_server_cmp <- sd(dataCompression_Q06$Server_Total_Energy)
sdQ6_server_cmp # 2.119378
sdQ6_server_cmp / mQ6_server_cmp # 0.06304827

wilcox.test(dataCompression_Q06$Juliet_Client_Total_Energy, dataBase_Q06$Juliet_Client_Total_Energy) # W = 268, p-value = 0.00665
wilcox.test(dataCompression_Q06$Server_Total_Energy, dataBase_Q06$Server_Total_Energy) # W = 222, p-value = 0.0005762
wilcox.test(dataCompression_Q06$Total_Energy, dataBase_Q06$Total_Energy) # W = 159, p-value = 6.793e-06

x6_client_cmp <- (mQ6_client_cmp / mQ6_client_base) * 100
100 - x6_client_cmp # 6.51341

x6_server_cmp <- (mQ6_server_cmp / mQ6_server_base) * 100
100 - x6_server_cmp # 5.280068

# Index-Compression Q6
dataIC_Q06 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q06' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q06)

mQ6_client_IC <- mean(dataIC_Q06$Juliet_Client_Total_Energy)
mQ6_client_IC # 18.657
sdQ6_client_IC <- sd(dataIC_Q06$Juliet_Client_Total_Energy)
sdQ6_client_IC # 2.042458
sdQ6_client_IC / mQ6_client_IC # 0.1094741

mQ6_server_IC <- mean(dataIC_Q06$Server_Total_Energy)
mQ6_server_IC # 36.13667
sdQ6_server_IC <- sd(dataIC_Q06$Server_Total_Energy)
sdQ6_server_IC # 2.364484
sdQ6_server_IC / mQ6_server_IC # 0.06543171

wilcox.test(dataIC_Q06$Juliet_Client_Total_Energy, dataBase_Q06$Juliet_Client_Total_Energy) # W = 308, p-value = 0.03577
wilcox.test(dataIC_Q06$Server_Total_Energy, dataBase_Q06$Server_Total_Energy) # W = 533, p-value = 0.2244
wilcox.test(dataIC_Q06$Total_Energy, dataBase_Q06$Total_Energy) # W = 469, p-value = 0.786

x6_client_IC <- (mQ6_client_IC / mQ6_client_base) * 100
100 - x6_client_IC # 4.716783

x6_server_IC <- (mQ6_server_IC / mQ6_server_base) * 100
100 - x6_server_IC # -1.824969

#### Q7 ####
# Base Q7
dataBase_Q07 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q07' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q07)

mQ7_client_base <- mean(dataBase_Q07$Juliet_Client_Total_Energy)
mQ7_client_base # 18.24035
sdQ7_client_base <- sd(dataBase_Q07$Juliet_Client_Total_Energy)
sdQ7_client_base # 2.465255
sdQ7_client_base / mQ7_client_base # 0.1351539

mQ7_server_base <- mean(dataBase_Q07$Server_Total_Energy)
mQ7_server_base # 28.8783
sdQ7_server_base <- sd(dataBase_Q07$Server_Total_Energy)
sdQ7_server_base # 1.92879
sdQ7_server_base / mQ7_server_base # 0.06679031

# Index Q7
dataIndex_Q07 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q07' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q07)

mQ7_client_index <- mean(dataIndex_Q07$Juliet_Client_Total_Energy)
mQ7_client_index # 18.4716
sdQ7_client_index <- sd(dataIndex_Q07$Juliet_Client_Total_Energy)
sdQ7_client_index # 1.923164
sdQ7_client_index / mQ7_client_index # 0.1041147

mQ7_server_index <- mean(dataIndex_Q07$Server_Total_Energy)
mQ7_server_index # 33.8229
sdQ7_server_index <- sd(dataIndex_Q07$Server_Total_Energy)
sdQ7_server_index # 2.449968
sdQ7_server_index / mQ7_server_index # 0.07243517

wilcox.test(dataIndex_Q07$Juliet_Client_Total_Energy, dataBase_Q07$Juliet_Client_Total_Energy) # W = 494, p-value = 0.5229
wilcox.test(dataIndex_Q07$Server_Total_Energy, dataBase_Q07$Server_Total_Energy) # W = 854, p-value = 1.084e-11
wilcox.test(dataIndex_Q07$Total_Energy, dataBase_Q07$Total_Energy) # W = 767, p-value = 6.816e-07

x7_client_index <- (mQ7_client_index / mQ7_client_base) * 100
100 - x7_client_index # -1.267757

x7_server_index <- (mQ7_server_index / mQ7_server_base) * 100
100 - x7_server_index # -17.12221

# Compression Q7
dataCompression_Q07 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q07' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q07)

mQ7_client_cmp <- mean(dataCompression_Q07$Juliet_Client_Total_Energy)
mQ7_client_cmp # 18.6423
sdQ7_client_cmp <- sd(dataCompression_Q07$Juliet_Client_Total_Energy)
sdQ7_client_cmp # 1.934269
sdQ7_client_cmp / mQ7_client_cmp # 0.103757

mQ7_server_cmp <- mean(dataCompression_Q07$Server_Total_Energy)
mQ7_server_cmp # 30.57581
sdQ7_server_cmp <- sd(dataCompression_Q07$Server_Total_Energy)
sdQ7_server_cmp # 2.11659
sdQ7_server_cmp / mQ7_server_cmp # 0.06922434

wilcox.test(dataCompression_Q07$Juliet_Client_Total_Energy, dataBase_Q07$Juliet_Client_Total_Energy) # W = 538, p-value = 0.1973
wilcox.test(dataCompression_Q07$Server_Total_Energy, dataBase_Q07$Server_Total_Energy) # W = 646, p-value = 0.00336
wilcox.test(dataCompression_Q07$Total_Energy, dataBase_Q07$Total_Energy) # W = 617, p-value = 0.01307

x7_client_cmp <- (mQ7_client_cmp / mQ7_client_base) * 100
100 - x7_client_cmp # -2.203594

x7_server_cmp <- (mQ7_server_cmp / mQ7_server_base) * 100
100 - x7_server_cmp # -5.878163

# Index-Compression Q7
dataIC_Q07 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q07' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q07)

mQ7_client_IC <- mean(dataIC_Q07$Juliet_Client_Total_Energy)
mQ7_client_IC # 17.916
sdQ7_client_IC <- sd(dataIC_Q07$Juliet_Client_Total_Energy)
sdQ7_client_IC # 2.441404
sdQ7_client_IC / mQ7_client_IC # 0.1362694

mQ7_server_IC <- mean(dataIC_Q07$Server_Total_Energy)
mQ7_server_IC # 33.217
sdQ7_server_IC <- sd(dataIC_Q07$Server_Total_Energy)
sdQ7_server_IC # 2.540576
sdQ7_server_IC / mQ7_server_IC # 0.07648421

wilcox.test(dataIC_Q07$Juliet_Client_Total_Energy, dataBase_Q07$Juliet_Client_Total_Energy) # W = 412, p-value = 0.5819
wilcox.test(dataIC_Q07$Server_Total_Energy, dataBase_Q07$Server_Total_Energy) # W = 844, p-value = 5.799e-11
wilcox.test(dataIC_Q07$Total_Energy, dataBase_Q07$Total_Energy) # W = 684, p-value = 0.0004003

x7_client_IC <- (mQ7_client_IC / mQ7_client_base) * 100
100 - x7_client_IC # 1.7782

x7_server_IC <- (mQ7_server_IC / mQ7_server_base) * 100
100 - x7_server_IC # -15.02409

#### Q8 ####
# Base Q8
dataBase_Q08 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q08' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q08)

mQ8_client_base <- mean(dataBase_Q08$Juliet_Client_Total_Energy)
mQ8_client_base # 18.31687
sdQ8_client_base <- sd(dataBase_Q08$Juliet_Client_Total_Energy)
sdQ8_client_base # 2.276025
sdQ8_client_base / mQ8_client_base # 0.1242584

mQ8_server_base <- mean(dataBase_Q08$Server_Total_Energy)
mQ8_server_base # 30.88914
sdQ8_server_base <- sd(dataBase_Q08$Server_Total_Energy)
sdQ8_server_base # 1.687706
sdQ8_server_base / mQ8_server_base # 0.05463751

# Index Q8
dataIndex_Q08 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q08' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q08)

mQ8_client_index <- mean(dataIndex_Q08$Juliet_Client_Total_Energy)
mQ8_client_index # 17.78582
sdQ8_client_index <- sd(dataIndex_Q08$Juliet_Client_Total_Energy)
sdQ8_client_index # 1.602467
sdQ8_client_index / mQ8_client_index # 0.09009801

mQ8_server_index <- mean(dataIndex_Q08$Server_Total_Energy)
mQ8_server_index # 39.43272
sdQ8_server_index <- sd(dataIndex_Q08$Server_Total_Energy)
sdQ8_server_index # 1.713769
sdQ8_server_index / mQ8_server_index # 0.04346057

wilcox.test(dataIndex_Q08$Juliet_Client_Total_Energy, dataBase_Q08$Juliet_Client_Total_Energy) # W = 381, p-value = 0.3136
wilcox.test(dataIndex_Q08$Server_Total_Energy, dataBase_Q08$Server_Total_Energy) # W = 900, p-value < 2.2e-16
wilcox.test(dataIndex_Q08$Total_Energy, dataBase_Q08$Total_Energy) # W = 884, p-value = 1.547e-14

x8_client_index <- (mQ8_client_index / mQ8_client_base) * 100
100 - x8_client_index # 2.899276

x8_server_index <- (mQ8_server_index / mQ8_server_base) * 100
100 - x8_server_index # -27.65886

# Compression Q8
dataCompression_Q08 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q08' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q08)

mQ8_client_cmp <- mean(dataCompression_Q08$Juliet_Client_Total_Energy)
mQ8_client_cmp # 18.58269
sdQ8_client_cmp <- sd(dataCompression_Q08$Juliet_Client_Total_Energy)
sdQ8_client_cmp # 2.0288
sdQ8_client_cmp / mQ8_client_cmp # 0.1091769

mQ8_server_cmp <- mean(dataCompression_Q08$Server_Total_Energy)
mQ8_server_cmp # 29.42575
sdQ8_server_cmp <- sd(dataCompression_Q08$Server_Total_Energy)
sdQ8_server_cmp # 1.520744
sdQ8_server_cmp / mQ8_server_cmp # 0.05168073

wilcox.test(dataCompression_Q08$Juliet_Client_Total_Energy, dataBase_Q08$Juliet_Client_Total_Energy) # W = 478, p-value = 0.6865
wilcox.test(dataCompression_Q08$Server_Total_Energy, dataBase_Q08$Server_Total_Energy) # W = 245, p-value = 0.002107
wilcox.test(dataCompression_Q08$Total_Energy, dataBase_Q08$Total_Energy) # W = 370, p-value = 0.2418

x8_client_cmp <- (mQ8_client_cmp / mQ8_client_base) * 100
100 - x8_client_cmp # -1.451212

x8_server_cmp <- (mQ8_server_cmp / mQ8_server_base) * 100
100 - x8_server_cmp # 4.737544

# Index-Compression Q8
dataIC_Q08 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q08' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q08)

mQ8_client_IC <- mean(dataIC_Q08$Juliet_Client_Total_Energy)
mQ8_client_IC # 18.80617
sdQ8_client_IC <- sd(dataIC_Q08$Juliet_Client_Total_Energy)
sdQ8_client_IC # 2.060341
sdQ8_client_IC / mQ8_client_IC # 0.1095566

mQ8_server_IC <- mean(dataIC_Q08$Server_Total_Energy)
mQ8_server_IC # 38.1891
sdQ8_server_IC <- sd(dataIC_Q08$Server_Total_Energy)
sdQ8_server_IC # 1.645788
sdQ8_server_IC / mQ8_server_IC # 0.04309576

wilcox.test(dataIC_Q08$Juliet_Client_Total_Energy, dataBase_Q08$Juliet_Client_Total_Energy) # W = 498, p-value = 0.4853
wilcox.test(dataIC_Q08$Server_Total_Energy, dataBase_Q08$Server_Total_Energy) # W = 900, p-value < 2.2e-16
wilcox.test(dataIC_Q08$Total_Energy, dataBase_Q08$Total_Energy) # W = 872, p-value = 3.122e-13

x8_client_IC <- (mQ8_client_IC / mQ8_client_base) * 100
100 - x8_client_IC # -2.671271

x8_server_IC <- (mQ8_server_IC / mQ8_server_base) * 100
100 - x8_server_IC # -23.63278

#### Q9 ####
# Base Q9
dataBase_Q09 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q09' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q09)

mQ9_client_base <- mean(dataBase_Q09$Juliet_Client_Total_Energy)
mQ9_client_base # 18.98462
sdQ9_client_base <- sd(dataBase_Q09$Juliet_Client_Total_Energy)
sdQ9_client_base # 2.529175
sdQ9_client_base / mQ9_client_base # 0.1332223

mQ9_server_base <- mean(dataBase_Q09$Server_Total_Energy)
mQ9_server_base # 60.02157
sdQ9_server_base <- sd(dataBase_Q09$Server_Total_Energy)
sdQ9_server_base # 1.737497
sdQ9_server_base / mQ9_server_base # 0.02894788

# Index Q9
dataIndex_Q09 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q09' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q09)

mQ9_client_index <- mean(dataIndex_Q09$Juliet_Client_Total_Energy)
mQ9_client_index # 16.25886
sdQ9_client_index <- sd(dataIndex_Q09$Juliet_Client_Total_Energy)
sdQ9_client_index # 1.799201
sdQ9_client_index / mQ9_client_index # 0.1106597

mQ9_server_index <- mean(dataIndex_Q09$Server_Total_Energy)
mQ9_server_index # 9.228205
sdQ9_server_index <- sd(dataIndex_Q09$Server_Total_Energy)
sdQ9_server_index # 0.9757939
sdQ9_server_index / mQ9_server_index # 0.1057404

wilcox.test(dataIndex_Q09$Juliet_Client_Total_Energy, dataBase_Q09$Juliet_Client_Total_Energy) # W = 169, p-value = 1.517e-05
wilcox.test(dataIndex_Q09$Server_Total_Energy, dataBase_Q09$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIndex_Q09$Total_Energy, dataBase_Q09$Total_Energy) # W = 0, p-value < 2.2e-16

x9_client_index <- (mQ9_client_index / mQ9_client_base) * 100
100 - x9_client_index # 14.35772

x9_server_index <- (mQ9_server_index / mQ9_server_base) * 100
100 - x9_server_index # 84.62518

# Compression Q9
dataCompression_Q09 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q09' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q09)

mQ9_client_cmp <- mean(dataCompression_Q09$Juliet_Client_Total_Energy)
mQ9_client_cmp # 19.40175
sdQ9_client_cmp <- sd(dataCompression_Q09$Juliet_Client_Total_Energy)
sdQ9_client_cmp # 1.809858
sdQ9_client_cmp / mQ9_client_cmp # 0.09328323

mQ9_server_cmp <- mean(dataCompression_Q09$Server_Total_Energy)
mQ9_server_cmp # 56.66151
sdQ9_server_cmp <- sd(dataCompression_Q09$Server_Total_Energy)
sdQ9_server_cmp # 1.527026
sdQ9_server_cmp / mQ9_server_cmp # 0.02694997

wilcox.test(dataCompression_Q09$Juliet_Client_Total_Energy, dataBase_Q09$Juliet_Client_Total_Energy) # W = 506, p-value = 0.4147
wilcox.test(dataCompression_Q09$Server_Total_Energy, dataBase_Q09$Server_Total_Energy) # W = 72, p-value = 6.303e-10
wilcox.test(dataCompression_Q09$Total_Energy, dataBase_Q09$Total_Energy) # W = 202, p-value = 0.0001636

x9_client_cmp <- (mQ9_client_cmp / mQ9_client_base) * 100
100 - x9_client_cmp # -2.197199

x9_server_cmp <- (mQ9_server_cmp / mQ9_server_base) * 100
100 - x9_server_cmp # 5.598088

# Index-Compression Q9
dataIC_Q09 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q09' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q09)

mQ9_client_IC <- mean(dataIC_Q09$Juliet_Client_Total_Energy)
mQ9_client_IC # 16.61986
sdQ9_client_IC <- sd(dataIC_Q09$Juliet_Client_Total_Energy)
sdQ9_client_IC # 2.059436
sdQ9_client_IC / mQ9_client_IC # 0.1239142

mQ9_server_IC <- mean(dataIC_Q09$Server_Total_Energy)
mQ9_server_IC # 4.289035
sdQ9_server_IC <- sd(dataIC_Q09$Server_Total_Energy)
sdQ9_server_IC # 0.7894019
sdQ9_server_IC / mQ9_server_IC # 0.1840512

wilcox.test(dataIC_Q09$Juliet_Client_Total_Energy, dataBase_Q09$Juliet_Client_Total_Energy) # W = 215, p-value = 0.0003763
wilcox.test(dataIC_Q09$Server_Total_Energy, dataBase_Q09$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIC_Q09$Total_Energy, dataBase_Q09$Total_Energy) # W = 0, p-value < 2.2e-16

x9_client_IC <- (mQ9_client_IC / mQ9_client_base) * 100
100 - x9_client_IC # 12.4562

x9_server_IC <- (mQ9_server_IC / mQ9_server_base) * 100
100 - x9_server_IC # 92.85418

#### Q10 ####
# Base Q10
dataBase_Q10 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q10' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q10)

mQ10_client_base <- mean(dataBase_Q10$Juliet_Client_Total_Energy)
mQ10_client_base # 19.44782
sdQ10_client_base <- sd(dataBase_Q10$Juliet_Client_Total_Energy)
sdQ10_client_base # 1.599846
sdQ10_client_base / mQ10_client_base # 0.08226352

mQ10_server_base <- mean(dataBase_Q10$Server_Total_Energy)
mQ10_server_base # 57.7598
sdQ10_server_base <- sd(dataBase_Q10$Server_Total_Energy)
sdQ10_server_base # 1.675799
sdQ10_server_base / mQ10_server_base # 0.02901324

# Index Q10
dataIndex_Q10 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q10' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q10)

mQ10_client_index <- mean(dataIndex_Q10$Juliet_Client_Total_Energy)
mQ10_client_index # 18.95296
sdQ10_client_index <- sd(dataIndex_Q10$Juliet_Client_Total_Energy)
sdQ10_client_index # 2.19932
sdQ10_client_index / mQ10_client_index # 0.1160409

mQ10_server_index <- mean(dataIndex_Q10$Server_Total_Energy)
mQ10_server_index # 23.28154
sdQ10_server_index <- sd(dataIndex_Q10$Server_Total_Energy)
sdQ10_server_index # 1.295642
sdQ10_server_index / mQ10_server_index # 0.05565107

wilcox.test(dataIndex_Q10$Juliet_Client_Total_Energy, dataBase_Q10$Juliet_Client_Total_Energy) # W = 409, p-value = 0.552
wilcox.test(dataIndex_Q10$Server_Total_Energy, dataBase_Q10$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIndex_Q10$Total_Energy, dataBase_Q10$Total_Energy) # W = 0, p-value < 2.2e-16

x10_client_index <- (mQ10_client_index / mQ10_client_base) * 100
100 - x10_client_index # 2.544535

x10_server_index <- (mQ10_server_index / mQ10_server_base) * 100
100 - x10_server_index # 59.69249

# Compression Q10
dataCompression_Q10 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q10' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q10)

mQ10_client_cmp <- mean(dataCompression_Q10$Juliet_Client_Total_Energy)
mQ10_client_cmp # 19.48045
sdQ10_client_cmp <- sd(dataCompression_Q10$Juliet_Client_Total_Energy)
sdQ10_client_cmp # 1.945937
sdQ10_client_cmp / mQ10_client_cmp # 0.0998918

mQ10_server_cmp <- mean(dataCompression_Q10$Server_Total_Energy)
mQ10_server_cmp # 56.05381
sdQ10_server_cmp <- sd(dataCompression_Q10$Server_Total_Energy)
sdQ10_server_cmp # 1.720196
sdQ10_server_cmp / mQ10_server_cmp # 0.03068829

wilcox.test(dataCompression_Q10$Juliet_Client_Total_Energy, dataBase_Q10$Juliet_Client_Total_Energy) # W = 457, p-value = 0.924
wilcox.test(dataCompression_Q10$Server_Total_Energy, dataBase_Q10$Server_Total_Energy) # W = 205, p-value = 0.0001993
wilcox.test(dataCompression_Q10$Total_Energy, dataBase_Q10$Total_Energy) # W = 286, p-value = 0.01487

x10_client_cmp <- (mQ10_client_cmp / mQ10_client_base) * 100
100 - x10_client_cmp # -0.1677652

x10_server_cmp <- (mQ10_server_cmp / mQ10_server_base) * 100
100 - x10_server_cmp # 2.953594

# Index-Compression Q10
dataIC_Q10 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q10' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q10)

mQ10_client_IC <- mean(dataIC_Q10$Juliet_Client_Total_Energy)
mQ10_client_IC # 18.50323
sdQ10_client_IC <- sd(dataIC_Q10$Juliet_Client_Total_Energy)
sdQ10_client_IC # 1.777
sdQ10_client_IC / mQ10_client_IC # 0.09603732

mQ10_server_IC <- mean(dataIC_Q10$Server_Total_Energy)
mQ10_server_IC # 52.8589
sdQ10_server_IC <- sd(dataIC_Q10$Server_Total_Energy)
sdQ10_server_IC # 1.593217
sdQ10_server_IC / mQ10_server_IC # 0.03014093

wilcox.test(dataIC_Q10$Juliet_Client_Total_Energy, dataBase_Q10$Juliet_Client_Total_Energy) # W = 309, p-value = 0.03713
wilcox.test(dataIC_Q10$Server_Total_Energy, dataBase_Q10$Server_Total_Energy) # W = 20, p-value = 4.59e-14
wilcox.test(dataIC_Q10$Total_Energy, dataBase_Q10$Total_Energy) # W = 55, p-value = 4.939e-11

x10_client_IC <- (mQ10_client_IC / mQ10_client_base) * 100
100 - x10_client_IC # 4.857065

x10_server_IC <- (mQ10_server_IC / mQ10_server_base) * 100
100 - x10_server_IC # 8.484961

#### Q11 ####
# Base Q11
dataBase_Q11 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q11' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q11)

mQ11_client_base <- mean(dataBase_Q11$Juliet_Client_Total_Energy)
mQ11_client_base # 17.47391
sdQ11_client_base <- sd(dataBase_Q11$Juliet_Client_Total_Energy)
sdQ11_client_base # 1.128075
sdQ11_client_base / mQ11_client_base # 0.06455769

mQ11_server_base <- mean(dataBase_Q11$Server_Total_Energy)
mQ11_server_base # 4.552296
sdQ11_server_base <- sd(dataBase_Q11$Server_Total_Energy)
sdQ11_server_base # 0.7328185
sdQ11_server_base / mQ11_server_base # 0.1609778

# Index Q11
dataIndex_Q11 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q11' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q11)

mQ11_client_index <- mean(dataIndex_Q11$Juliet_Client_Total_Energy)
mQ11_client_index # 15.37856
sdQ11_client_index <- sd(dataIndex_Q11$Juliet_Client_Total_Energy)
sdQ11_client_index # 1.580133
sdQ11_client_index / mQ11_client_index # 0.1027491

mQ11_server_index <- mean(dataIndex_Q11$Server_Total_Energy)
mQ11_server_index # 1.979591
sdQ11_server_index <- sd(dataIndex_Q11$Server_Total_Energy)
sdQ11_server_index # 0.6087287
sdQ11_server_index / mQ11_server_index # 0.3075022

wilcox.test(dataIndex_Q11$Juliet_Client_Total_Energy, dataBase_Q11$Juliet_Client_Total_Energy) # W = 131, p-value = 5.633e-07
wilcox.test(dataIndex_Q11$Server_Total_Energy, dataBase_Q11$Server_Total_Energy) # W = 1, p-value < 2.2e-16
wilcox.test(dataIndex_Q11$Total_Energy, dataBase_Q11$Total_Energy) # W = 24, p-value = 1.241e-13

x11_client_index <- (mQ11_client_index / mQ11_client_base) * 100
100 - x11_client_index # 11.99131

x11_server_index <- (mQ11_server_index / mQ11_server_base) * 100
100 - x11_server_index # 56.51444

# Compression Q11
dataCompression_Q11 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q11' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q11)

mQ11_client_cmp <- mean(dataCompression_Q11$Juliet_Client_Total_Energy)
mQ11_client_cmp # 16.74171
sdQ11_client_cmp <- sd(dataCompression_Q11$Juliet_Client_Total_Energy)
sdQ11_client_cmp # 1.477895
sdQ11_client_cmp / mQ11_client_cmp # 0.08827625

mQ11_server_cmp <- mean(dataCompression_Q11$Server_Total_Energy)
mQ11_server_cmp # 4.819435
sdQ11_server_cmp <- sd(dataCompression_Q11$Server_Total_Energy)
sdQ11_server_cmp # 0.6848955
sdQ11_server_cmp / mQ11_server_cmp # 0.1421112

wilcox.test(dataCompression_Q11$Juliet_Client_Total_Energy, dataBase_Q11$Juliet_Client_Total_Energy) # W = 321, p-value = 0.0853
wilcox.test(dataCompression_Q11$Server_Total_Energy, dataBase_Q11$Server_Total_Energy) # W = 509, p-value = 0.2673
wilcox.test(dataCompression_Q11$Total_Energy, dataBase_Q11$Total_Energy) # W = 386, p-value = 0.465

x11_client_cmp <- (mQ11_client_cmp / mQ11_client_base) * 100
100 - x11_client_cmp # 4.190245

x11_server_cmp <- (mQ11_server_cmp / mQ11_server_base) * 100
100 - x11_server_cmp # -5.868214

# Index-Compression Q11
dataIC_Q11 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q11' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q11)

mQ11_client_IC <- mean(dataIC_Q11$Juliet_Client_Total_Energy)
mQ11_client_IC # 14.78902
sdQ11_client_IC <- sd(dataIC_Q11$Juliet_Client_Total_Energy)
sdQ11_client_IC # 1.672727
sdQ11_client_IC / mQ11_client_IC # 0.113106

mQ11_server_IC <- mean(dataIC_Q11$Server_Total_Energy)
mQ11_server_IC # 1.356965
sdQ11_server_IC <- sd(dataIC_Q11$Server_Total_Energy)
sdQ11_server_IC # 0.5410488
sdQ11_server_IC / mQ11_server_IC # 0.3987197

wilcox.test(dataIC_Q11$Juliet_Client_Total_Energy, dataBase_Q11$Juliet_Client_Total_Energy) # W = 74, p-value = 8.315e-10
wilcox.test(dataIC_Q11$Server_Total_Energy, dataBase_Q11$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIC_Q11$Total_Energy, dataBase_Q11$Total_Energy) # W = 1, p-value < 2.2e-16

x11_client_IC <- (mQ11_client_IC / mQ11_client_base) * 100
100 - x11_client_IC # 15.36514

x11_server_IC <- (mQ11_server_IC / mQ11_server_base) * 100
100 - x11_server_IC # 70.19163

#### Q12 ####
# Base Q12
dataBase_Q12 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q12' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q12)

mQ12_client_base <- mean(dataBase_Q12$Juliet_Client_Total_Energy)
mQ12_client_base # 19.2276
sdQ12_client_base <- sd(dataBase_Q12$Juliet_Client_Total_Energy)
sdQ12_client_base # 1.900945
sdQ12_client_base / mQ12_client_base # 0.09886542

mQ12_server_base <- mean(dataBase_Q12$Server_Total_Energy)
mQ12_server_base # 56.08077
sdQ12_server_base <- sd(dataBase_Q12$Server_Total_Energy)
sdQ12_server_base # 1.847377
sdQ12_server_base / mQ12_server_base # 0.03294137

# Index Q12
dataIndex_Q12 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q12' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q12)

mQ12_client_index <- mean(dataIndex_Q12$Juliet_Client_Total_Energy)
mQ12_client_index # 18.07383
sdQ12_client_index <- sd(dataIndex_Q12$Juliet_Client_Total_Energy)
sdQ12_client_index # 2.170129
sdQ12_client_index / mQ12_client_index # 0.1200702

mQ12_server_index <- mean(dataIndex_Q12$Server_Total_Energy)
mQ12_server_index # 17.63134
sdQ12_server_index <- sd(dataIndex_Q12$Server_Total_Energy)
sdQ12_server_index # 1.389374
sdQ12_server_index / mQ12_server_index # 0.07880141

wilcox.test(dataIndex_Q12$Juliet_Client_Total_Energy, dataBase_Q12$Juliet_Client_Total_Energy) # W = 309, p-value = 0.03713
wilcox.test(dataIndex_Q12$Server_Total_Energy, dataBase_Q12$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIndex_Q12$Total_Energy, dataBase_Q12$Total_Energy) # W = 0, p-value < 2.2e-16

x12_client_index <- (mQ12_client_index / mQ12_client_base) * 100
100 - x12_client_index # 6.000592

x12_server_index <- (mQ12_server_index / mQ12_server_base) * 100
100 - x12_server_index # 68.56081

# Compression Q12
dataCompression_Q12 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q12' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q12)

mQ12_client_cmp <- mean(dataCompression_Q12$Juliet_Client_Total_Energy)
mQ12_client_cmp # 19.43588
sdQ12_client_cmp <- sd(dataCompression_Q12$Juliet_Client_Total_Energy)
sdQ12_client_cmp # 1.957302
sdQ12_client_cmp / mQ12_client_cmp # 0.1007056

mQ12_server_cmp <- mean(dataCompression_Q12$Server_Total_Energy)
mQ12_server_cmp # 53.3346
sdQ12_server_cmp <- sd(dataCompression_Q12$Server_Total_Energy)
sdQ12_server_cmp # 2.152962
sdQ12_server_cmp / mQ12_server_cmp # 0.04036708

wilcox.test(dataCompression_Q12$Juliet_Client_Total_Energy, dataBase_Q12$Juliet_Client_Total_Energy) # W = 481, p-value = 0.6543
wilcox.test(dataCompression_Q12$Server_Total_Energy, dataBase_Q12$Server_Total_Energy) # W = 149, p-value = 2.913e-06
wilcox.test(dataCompression_Q12$Total_Energy, dataBase_Q12$Total_Energy) # W = 225, p-value = 0.0006884

x12_client_cmp <- (mQ12_client_cmp / mQ12_client_base) * 100
100 - x12_client_cmp # -1.083234

x12_server_cmp <- (mQ12_server_cmp / mQ12_server_base) * 100
100 - x12_server_cmp # 4.896812

# Index-Compression Q12
dataIC_Q12 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q12' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q12)

mQ12_client_IC <- mean(dataIC_Q12$Juliet_Client_Total_Energy)
mQ12_client_IC # 15.18279
sdQ12_client_IC <- sd(dataIC_Q12$Juliet_Client_Total_Energy)
sdQ12_client_IC # 2.249501
sdQ12_client_IC / mQ12_client_IC # 0.1481613

mQ12_server_IC <- mean(dataIC_Q12$Server_Total_Energy)
mQ12_server_IC # 11.74236
sdQ12_server_IC <- sd(dataIC_Q12$Server_Total_Energy)
sdQ12_server_IC # 1.167534
sdQ12_server_IC / mQ12_server_IC # 0.09942921

wilcox.test(dataIC_Q12$Juliet_Client_Total_Energy, dataBase_Q12$Juliet_Client_Total_Energy) # W = 88, p-value = 5.184e-09
wilcox.test(dataIC_Q12$Server_Total_Energy, dataBase_Q12$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIC_Q12$Total_Energy, dataBase_Q12$Total_Energy) # W = 0, p-value < 2.2e-16

x12_client_IC <- (mQ12_client_IC / mQ12_client_base) * 100
100 - x12_client_IC # 21.03651

x12_server_IC <- (mQ12_server_IC / mQ12_server_base) * 100
100 - x12_server_IC # 79.06169

#### Q13 ####
# Base Q13
dataBase_Q13 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q13' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q13)

mQ13_client_base <- mean(dataBase_Q13$Juliet_Client_Total_Energy)
mQ13_client_base # 19.11612
sdQ13_client_base <- sd(dataBase_Q13$Juliet_Client_Total_Energy)
sdQ13_client_base # 1.745674
sdQ13_client_base / mQ13_client_base # 0.09131948

mQ13_server_base <- mean(dataBase_Q13$Server_Total_Energy)
mQ13_server_base # 49.70985
sdQ13_server_base <- sd(dataBase_Q13$Server_Total_Energy)
sdQ13_server_base # 2.050069
sdQ13_server_base / mQ13_server_base # 0.0412407

# Index Q13
dataIndex_Q13 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q13' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q13)

mQ13_client_index <- mean(dataIndex_Q13$Juliet_Client_Total_Energy)
mQ13_client_index # 19.01801
sdQ13_client_index <- sd(dataIndex_Q13$Juliet_Client_Total_Energy)
sdQ13_client_index # 2.237606
sdQ13_client_index / mQ13_client_index # 0.1176572

mQ13_server_index <- mean(dataIndex_Q13$Server_Total_Energy)
mQ13_server_index # 48.05366
sdQ13_server_index <- sd(dataIndex_Q13$Server_Total_Energy)
sdQ13_server_index # 1.921109
sdQ13_server_index / mQ13_server_index # 0.03997841

wilcox.test(dataIndex_Q13$Juliet_Client_Total_Energy, dataBase_Q13$Juliet_Client_Total_Energy) # W = 435, p-value = 0.8315
wilcox.test(dataIndex_Q13$Server_Total_Energy, dataBase_Q13$Server_Total_Energy) # W = 248, p-value = 0.002468
wilcox.test(dataIndex_Q13$Total_Energy, dataBase_Q13$Total_Energy) # W = 290, p-value = 0.01759

x13_client_index <- (mQ13_client_index / mQ13_client_base) * 100
100 - x13_client_index # 0.513197

x13_server_index <- (mQ13_server_index / mQ13_server_base) * 100
100 - x13_server_index # 3.331714

# Compression Q13
dataCompression_Q13 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q13' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q13)

mQ13_client_cmp <- mean(dataCompression_Q13$Juliet_Client_Total_Energy)
mQ13_client_cmp # 18.74953
sdQ13_client_cmp <- sd(dataCompression_Q13$Juliet_Client_Total_Energy)
sdQ13_client_cmp # 1.854057
sdQ13_client_cmp / mQ13_client_cmp # 0.09888554

mQ13_server_cmp <- mean(dataCompression_Q13$Server_Total_Energy)
mQ13_server_cmp # 48.63179
sdQ13_server_cmp <- sd(dataCompression_Q13$Server_Total_Energy)
sdQ13_server_cmp # 2.124273
sdQ13_server_cmp / mQ13_server_cmp # 0.04368074

wilcox.test(dataCompression_Q13$Juliet_Client_Total_Energy, dataBase_Q13$Juliet_Client_Total_Energy) # W = 395, p-value = 0.4232
wilcox.test(dataCompression_Q13$Server_Total_Energy, dataBase_Q13$Server_Total_Energy) # W = 328, p-value = 0.07228
wilcox.test(dataCompression_Q13$Total_Energy, dataBase_Q13$Total_Energy) # W = 321, p-value = 0.05706

x13_client_cmp <- (mQ13_client_cmp / mQ13_client_base) * 100
100 - x13_client_cmp # 1.917701

x13_server_cmp <- (mQ13_server_cmp / mQ13_server_base) * 100
100 - x13_server_cmp # 2.168698

# Index-Compression Q13
dataIC_Q13 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q13' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q13)

mQ13_client_IC <- mean(dataIC_Q13$Juliet_Client_Total_Energy)
mQ13_client_IC # 17.93622
sdQ13_client_IC <- sd(dataIC_Q13$Juliet_Client_Total_Energy)
sdQ13_client_IC # 2.015308
sdQ13_client_IC / mQ13_client_IC # 0.1123597

mQ13_server_IC <- mean(dataIC_Q13$Server_Total_Energy)
mQ13_server_IC # 48.38217
sdQ13_server_IC <- sd(dataIC_Q13$Server_Total_Energy)
sdQ13_server_IC # 2.599152
sdQ13_server_IC / mQ13_server_IC # 0.05372128

wilcox.test(dataIC_Q13$Juliet_Client_Total_Energy, dataBase_Q13$Juliet_Client_Total_Energy) # W = 284, p-value = 0.01365
wilcox.test(dataIC_Q13$Server_Total_Energy, dataBase_Q13$Server_Total_Energy) # W = 306, p-value = 0.03318
wilcox.test(dataIC_Q13$Total_Energy, dataBase_Q13$Total_Energy) # W = 258, p-value = 0.004105

x13_client_IC <- (mQ13_client_IC / mQ13_client_base) * 100
100 - x13_client_IC # 6.172261

x13_server_IC <- (mQ13_server_IC / mQ13_server_base) * 100
100 - x13_server_IC # 2.670866

#### Q14 ####
# Base Q14
dataBase_Q14 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q14' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q14)

mQ14_client_base <- mean(dataBase_Q14$Juliet_Client_Total_Energy)
mQ14_client_base # 18.9986
sdQ14_client_base <- sd(dataBase_Q14$Juliet_Client_Total_Energy)
sdQ14_client_base # 2.204835
sdQ14_client_base / mQ14_client_base # 0.1160525

mQ14_server_base <- mean(dataBase_Q14$Server_Total_Energy)
mQ14_server_base # 35.42503
sdQ14_server_base <- sd(dataBase_Q14$Server_Total_Energy)
sdQ14_server_base # 2.329415
sdQ14_server_base / mQ14_server_base # 0.06575619

# Index Q14
dataIndex_Q14 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q14' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q14)

mQ14_client_index <- mean(dataIndex_Q14$Juliet_Client_Total_Energy)
mQ14_client_index # 17.14564
sdQ14_client_index <- sd(dataIndex_Q14$Juliet_Client_Total_Energy)
sdQ14_client_index # 2.079697
sdQ14_client_index / mQ14_client_index # 0.121296

mQ14_server_index <- mean(dataIndex_Q14$Server_Total_Energy)
mQ14_server_index # 7.30852
sdQ14_server_index <- sd(dataIndex_Q14$Server_Total_Energy)
sdQ14_server_index # 1.95798
sdQ14_server_index / mQ14_server_index # 0.2679038

wilcox.test(dataIndex_Q14$Juliet_Client_Total_Energy, dataBase_Q14$Juliet_Client_Total_Energy) # W = 255, p-value = 0.003534
wilcox.test(dataIndex_Q14$Server_Total_Energy, dataBase_Q14$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIndex_Q14$Total_Energy, dataBase_Q14$Total_Energy) # W = 0, p-value < 2.2e-16

x14_client_index <- (mQ14_client_index / mQ14_client_base) * 100
100 - x14_client_index # 9.753156

x14_server_index <- (mQ14_server_index / mQ14_server_base) * 100
100 - x14_server_index # 79.36905

# Compression Q14
dataCompression_Q14 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q14' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q14)

mQ14_client_cmp <- mean(dataCompression_Q14$Juliet_Client_Total_Energy)
mQ14_client_cmp # 18.44094
sdQ14_client_cmp <- sd(dataCompression_Q14$Juliet_Client_Total_Energy)
sdQ14_client_cmp # 1.586997
sdQ14_client_cmp / mQ14_client_cmp # 0.08605835

mQ14_server_cmp <- mean(dataCompression_Q14$Server_Total_Energy)
mQ14_server_cmp # 32.33912
sdQ14_server_cmp <- sd(dataCompression_Q14$Server_Total_Energy)
sdQ14_server_cmp # 2.197611
sdQ14_server_cmp / mQ14_server_cmp # 0.06795517

wilcox.test(dataCompression_Q14$Juliet_Client_Total_Energy, dataBase_Q14$Juliet_Client_Total_Energy) # W = 379, p-value = 0.2996
wilcox.test(dataCompression_Q14$Server_Total_Energy, dataBase_Q14$Server_Total_Energy) # W = 149, p-value = 2.913e-06
wilcox.test(dataCompression_Q14$Total_Energy, dataBase_Q14$Total_Energy) # W = 179, p-value = 3.255e-05

x14_client_cmp <- (mQ14_client_cmp / mQ14_client_base) * 100
100 - x14_client_cmp # 2.935286

x14_server_cmp <- (mQ14_server_cmp / mQ14_server_base) * 100
100 - x14_server_cmp # 8.7111

# Index-Compression Q14
dataIC_Q14 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q14' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q14)

mQ14_client_IC <- mean(dataIC_Q14$Juliet_Client_Total_Energy)
mQ14_client_IC # 16.73941
sdQ14_client_IC <- sd(dataIC_Q14$Juliet_Client_Total_Energy)
sdQ14_client_IC # 1.561908
sdQ14_client_IC / mQ14_client_IC # 0.09330721

mQ14_server_IC <- mean(dataIC_Q14$Server_Total_Energy)
mQ14_server_IC # 7.321269
sdQ14_server_IC <- sd(dataIC_Q14$Server_Total_Energy)
sdQ14_server_IC # 1.576905
sdQ14_server_IC / mQ14_server_IC # 0.2153868

wilcox.test(dataIC_Q14$Juliet_Client_Total_Energy, dataBase_Q14$Juliet_Client_Total_Energy) # W = 198, p-value = 0.0001252
wilcox.test(dataIC_Q14$Server_Total_Energy, dataBase_Q14$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIC_Q14$Total_Energy, dataBase_Q14$Total_Energy) # W = 0, p-value < 2.2e-16

x14_client_IC <- (mQ14_client_IC / mQ14_client_base) * 100
100 - x14_client_IC # 11.89135

x14_server_IC <- (mQ14_server_IC / mQ14_server_base) * 100
100 - x14_server_IC # 79.33306

#### Q15 ####
# Base Q15
dataBase_Q15 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q15' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q15)

mQ15_client_base <- mean(dataBase_Q15$Juliet_Client_Total_Energy)
mQ15_client_base # 26.16299
sdQ15_client_base <- sd(dataBase_Q15$Juliet_Client_Total_Energy)
sdQ15_client_base # 5.416223
sdQ15_client_base / mQ15_client_base # 0.2070185

mQ15_server_base <- mean(dataBase_Q15$Server_Total_Energy)
mQ15_server_base # 98.1017
sdQ15_server_base <- sd(dataBase_Q15$Server_Total_Energy)
sdQ15_server_base # 16.10278
sdQ15_server_base / mQ15_server_base # 0.1641438

# Index Q15
dataIndex_Q15 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q15' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q15)

mQ15_client_index <- mean(dataIndex_Q15$Juliet_Client_Total_Energy)
mQ15_client_index # 18.59872
sdQ15_client_index <- sd(dataIndex_Q15$Juliet_Client_Total_Energy)
sdQ15_client_index # 1.991842
sdQ15_client_index / mQ15_client_index # 0.1070957

mQ15_server_index <- mean(dataIndex_Q15$Server_Total_Energy)
mQ15_server_index # 46.70129
sdQ15_server_index <- sd(dataIndex_Q15$Server_Total_Energy)
sdQ15_server_index # 3.45382
sdQ15_server_index / mQ15_server_index # 0.07395555

wilcox.test(dataIndex_Q15$Juliet_Client_Total_Energy, dataBase_Q15$Juliet_Client_Total_Energy) # W = 127, p-value = 3.823e-07
wilcox.test(dataIndex_Q15$Server_Total_Energy, dataBase_Q15$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIndex_Q15$Total_Energy, dataBase_Q15$Total_Energy) # W = 0, p-value < 2.2e-16

x15_client_index <- (mQ15_client_index / mQ15_client_base) * 100
100 - x15_client_index # 28.91211

x15_server_index <- (mQ15_server_index / mQ15_server_base) * 100
100 - x15_server_index # 52.39502

# Compression Q15
dataCompression_Q15 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q15' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q15)

mQ15_client_cmp <- mean(dataCompression_Q15$Juliet_Client_Total_Energy)
mQ15_client_cmp # 19.80371
sdQ15_client_cmp <- sd(dataCompression_Q15$Juliet_Client_Total_Energy)
sdQ15_client_cmp # 2.04082
sdQ15_client_cmp / mQ15_client_cmp # 0.1030524

mQ15_server_cmp <- mean(dataCompression_Q15$Server_Total_Energy)
mQ15_server_cmp # 73.51114
sdQ15_server_cmp <- sd(dataCompression_Q15$Server_Total_Energy)
sdQ15_server_cmp # 2.550499
sdQ15_server_cmp / mQ15_server_cmp # 0.03469541

wilcox.test(dataCompression_Q15$Juliet_Client_Total_Energy, dataBase_Q15$Juliet_Client_Total_Energy) # W = 185, p-value = 5.053e-05
wilcox.test(dataCompression_Q15$Server_Total_Energy, dataBase_Q15$Server_Total_Energy) # W = 46, p-value = 1.084e-11
wilcox.test(dataCompression_Q15$Total_Energy, dataBase_Q15$Total_Energy) # W = 64, p-value = 1.99e-10

x15_client_cmp <- (mQ15_client_cmp / mQ15_client_base) * 100
100 - x15_client_cmp # 24.30638

x15_server_cmp <- (mQ15_server_cmp / mQ15_server_base) * 100
100 - x15_server_cmp # 25.0664

# Index-Compression Q15
dataIC_Q15 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q15' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q15)

mQ15_client_IC <- mean(dataIC_Q15$Juliet_Client_Total_Energy)
mQ15_client_IC # 18.18977
sdQ15_client_IC <- sd(dataIC_Q15$Juliet_Client_Total_Energy)
sdQ15_client_IC # 1.901702
sdQ15_client_IC / mQ15_client_IC # 0.1045479

mQ15_server_IC <- mean(dataIC_Q15$Server_Total_Energy)
mQ15_server_IC # 47.25605
sdQ15_server_IC <- sd(dataIC_Q15$Server_Total_Energy)
sdQ15_server_IC # 2.639595
sdQ15_server_IC / mQ15_server_IC # 0.0558573

wilcox.test(dataIC_Q15$Juliet_Client_Total_Energy, dataBase_Q15$Juliet_Client_Total_Energy) # W = 103, p-value = 3.065e-08
wilcox.test(dataIC_Q15$Server_Total_Energy, dataBase_Q15$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIC_Q15$Total_Energy, dataBase_Q15$Total_Energy) # W = 0, p-value < 2.2e-16

x15_client_IC <- (mQ15_client_IC / mQ15_client_base) * 100
100 - x15_client_IC # 30.47519

x15_server_IC <- (mQ15_server_IC / mQ15_server_base) * 100
100 - x15_server_IC # 51.82953

#### Q16 ####
# Base Q16
dataBase_Q16 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q16' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q16)

mQ16_client_base <- mean(dataBase_Q16$Juliet_Client_Total_Energy)
mQ16_client_base # 25.01128
sdQ16_client_base <- sd(dataBase_Q16$Juliet_Client_Total_Energy)
sdQ16_client_base # 1.377051
sdQ16_client_base / mQ16_client_base # 0.0550572

mQ16_server_base <- mean(dataBase_Q16$Server_Total_Energy)
mQ16_server_base # 24.75673
sdQ16_server_base <- sd(dataBase_Q16$Server_Total_Energy)
sdQ16_server_base # 1.61694
sdQ16_server_base / mQ16_server_base # 0.06531315

# Index Q16
dataIndex_Q16 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q16' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q16)

mQ16_client_index <- mean(dataIndex_Q16$Juliet_Client_Total_Energy)
mQ16_client_index # 16.69711
sdQ16_client_index <- sd(dataIndex_Q16$Juliet_Client_Total_Energy)
sdQ16_client_index # 1.52336
sdQ16_client_index / mQ16_client_index # 0.09123491

mQ16_server_index <- mean(dataIndex_Q16$Server_Total_Energy)
mQ16_server_index # 17.13761
sdQ16_server_index <- sd(dataIndex_Q16$Server_Total_Energy)
sdQ16_server_index # 2.017499
sdQ16_server_index / mQ16_server_index # 0.1177234

wilcox.test(dataIndex_Q16$Juliet_Client_Total_Energy, dataBase_Q16$Juliet_Client_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIndex_Q16$Server_Total_Energy, dataBase_Q16$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIndex_Q16$Total_Energy, dataBase_Q16$Total_Energy) # W = 0, p-value < 2.2e-16

x16_client_index <- (mQ16_client_index / mQ16_client_base) * 100
100 - x16_client_index # 33.24167

x16_server_index <- (mQ16_server_index / mQ16_server_base) * 100
100 - x16_server_index # 30.77595

# Compression Q16
dataCompression_Q16 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q16' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q16)

mQ16_client_cmp <- mean(dataCompression_Q16$Juliet_Client_Total_Energy)
mQ16_client_cmp # 17.02255
sdQ16_client_cmp <- sd(dataCompression_Q16$Juliet_Client_Total_Energy)
sdQ16_client_cmp # 1.647062
sdQ16_client_cmp / mQ16_client_cmp # 0.09675766

mQ16_server_cmp <- mean(dataCompression_Q16$Server_Total_Energy)
mQ16_server_cmp # 18.49842
sdQ16_server_cmp <- sd(dataCompression_Q16$Server_Total_Energy)
sdQ16_server_cmp # 1.550313
sdQ16_server_cmp / mQ16_server_cmp # 0.0838079

wilcox.test(dataCompression_Q16$Juliet_Client_Total_Energy, dataBase_Q16$Juliet_Client_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataCompression_Q16$Server_Total_Energy, dataBase_Q16$Server_Total_Energy) # W = 1, p-value < 2.2e-16
wilcox.test(dataCompression_Q16$Total_Energy, dataBase_Q16$Total_Energy) # W = 0, p-value < 2.2e-16

x16_client_cmp <- (mQ16_client_cmp / mQ16_client_base) * 100
100 - x16_client_cmp # 31.9405

x16_server_cmp <- (mQ16_server_cmp / mQ16_server_base) * 100
100 - x16_server_cmp # 25.27925

# Index-Compression Q16
dataIC_Q16 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q16' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q16)

mQ16_client_IC <- mean(dataIC_Q16$Juliet_Client_Total_Energy)
mQ16_client_IC # 15.3752
sdQ16_client_IC <- sd(dataIC_Q16$Juliet_Client_Total_Energy)
sdQ16_client_IC # 1.458574
sdQ16_client_IC / mQ16_client_IC # 0.09486537

mQ16_server_IC <- mean(dataIC_Q16$Server_Total_Energy)
mQ16_server_IC # 17.8973
sdQ16_server_IC <- sd(dataIC_Q16$Server_Total_Energy)
sdQ16_server_IC # 0.9460269
sdQ16_server_IC / mQ16_server_IC # 0.05285865

wilcox.test(dataIC_Q16$Juliet_Client_Total_Energy, dataBase_Q16$Juliet_Client_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIC_Q16$Server_Total_Energy, dataBase_Q16$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIC_Q16$Total_Energy, dataBase_Q16$Total_Energy) # W = 0, p-value < 2.2e-16

x16_client_IC <- (mQ16_client_IC / mQ16_client_base) * 100
100 - x16_client_IC # 38.52695

x16_server_IC <- (mQ16_server_IC / mQ16_server_base) * 100
100 - x16_server_IC # 27.70736

#### Q17 ####
# Base Q17
dataBase_Q17 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q17' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q17)

mQ17_client_base <- mean(dataBase_Q17$Juliet_Client_Total_Energy)
mQ17_client_base # 43.78109
sdQ17_client_base <- sd(dataBase_Q17$Juliet_Client_Total_Energy)
sdQ17_client_base # 3.520448
sdQ17_client_base / mQ17_client_base # 0.08041023

mQ17_server_base <- mean(dataBase_Q17$Server_Total_Energy)
mQ17_server_base # 393.8253
sdQ17_server_base <- sd(dataBase_Q17$Server_Total_Energy)
sdQ17_server_base # 11.93277
sdQ17_server_base / mQ17_server_base # 0.03029966

# Index Q17
dataIndex_Q17 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q17' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q17)

mQ17_client_index <- mean(dataIndex_Q17$Juliet_Client_Total_Energy)
mQ17_client_index # 22.74048
sdQ17_client_index <- sd(dataIndex_Q17$Juliet_Client_Total_Energy)
sdQ17_client_index # 1.974798
sdQ17_client_index / mQ17_client_index # 0.08684064

mQ17_server_index <- mean(dataIndex_Q17$Server_Total_Energy)
mQ17_server_index # 241.7268
sdQ17_server_index <- sd(dataIndex_Q17$Server_Total_Energy)
sdQ17_server_index # 2.72098
sdQ17_server_index / mQ17_server_index # 0.01125643

wilcox.test(dataIndex_Q17$Juliet_Client_Total_Energy, dataBase_Q17$Juliet_Client_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIndex_Q17$Server_Total_Energy, dataBase_Q17$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIndex_Q17$Total_Energy, dataBase_Q17$Total_Energy) # W = 0, p-value < 2.2e-16

x17_client_index <- (mQ17_client_index / mQ17_client_base) * 100
100 - x17_client_index # 48.05868

x17_server_index <- (mQ17_server_index / mQ17_server_base) * 100
100 - x17_server_index # 38.6208

# Compression Q17
dataCompression_Q17 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q17' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q17)

mQ17_client_cmp <- mean(dataCompression_Q17$Juliet_Client_Total_Energy)
mQ17_client_cmp # 23.75961
sdQ17_client_cmp <- sd(dataCompression_Q17$Juliet_Client_Total_Energy)
sdQ17_client_cmp # 1.799591
sdQ17_client_cmp / mQ17_client_cmp # 0.07574161

mQ17_server_cmp <- mean(dataCompression_Q17$Server_Total_Energy)
mQ17_server_cmp # 265.727
sdQ17_server_cmp <- sd(dataCompression_Q17$Server_Total_Energy)
sdQ17_server_cmp # 4.132572
sdQ17_server_cmp / mQ17_server_cmp # 0.01555195

wilcox.test(dataCompression_Q17$Juliet_Client_Total_Energy, dataBase_Q17$Juliet_Client_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataCompression_Q17$Server_Total_Energy, dataBase_Q17$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataCompression_Q17$Total_Energy, dataBase_Q17$Total_Energy) # W = 0, p-value < 2.2e-16

x17_client_cmp <- (mQ17_client_cmp / mQ17_client_base) * 100
100 - x17_client_cmp # 45.73089

x17_server_cmp <- (mQ17_server_cmp / mQ17_server_base) * 100
100 - x17_server_cmp # 32.52669

# Index-Compression Q17
dataIC_Q17 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q17' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q17)

mQ17_client_IC <- mean(dataIC_Q17$Juliet_Client_Total_Energy)
mQ17_client_IC # 23.39481
sdQ17_client_IC <- sd(dataIC_Q17$Juliet_Client_Total_Energy)
sdQ17_client_IC # 2.427955
sdQ17_client_IC / mQ17_client_IC # 0.1037818

mQ17_server_IC <- mean(dataIC_Q17$Server_Total_Energy)
mQ17_server_IC # 238.5084
sdQ17_server_IC <- sd(dataIC_Q17$Server_Total_Energy)
sdQ17_server_IC # 4.750868
sdQ17_server_IC / mQ17_server_IC # 0.01991908

wilcox.test(dataIC_Q17$Juliet_Client_Total_Energy, dataBase_Q17$Juliet_Client_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIC_Q17$Server_Total_Energy, dataBase_Q17$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIC_Q17$Total_Energy, dataBase_Q17$Total_Energy) # W = 0, p-value < 2.2e-16

x17_client_IC <- (mQ17_client_IC / mQ17_client_base) * 100
100 - x17_client_IC # 46.56413

x17_server_IC <- (mQ17_server_IC / mQ17_server_base) * 100
100 - x17_server_IC # 39.43802

#### Q18 ####
# Base Q18
dataBase_Q18 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q18' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q18)

mQ18_client_base <- mean(dataBase_Q18$Juliet_Client_Total_Energy)
mQ18_client_base # 38.64319
sdQ18_client_base <- sd(dataBase_Q18$Juliet_Client_Total_Energy)
sdQ18_client_base # 8.089137
sdQ18_client_base / mQ18_client_base # 0.2093289

mQ18_server_base <- mean(dataBase_Q18$Server_Total_Energy)
mQ18_server_base # 334.9304
sdQ18_server_base <- sd(dataBase_Q18$Server_Total_Energy)
sdQ18_server_base # 31.5478
sdQ18_server_base / mQ18_server_base # 0.0941921

# Index Q18
dataIndex_Q18 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q18' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q18)

mQ18_client_index <- mean(dataIndex_Q18$Juliet_Client_Total_Energy)
mQ18_client_index # 23.57174
sdQ18_client_index <- sd(dataIndex_Q18$Juliet_Client_Total_Energy)
sdQ18_client_index # 1.828037
sdQ18_client_index / mQ18_client_index # 0.07755208

mQ18_server_index <- mean(dataIndex_Q18$Server_Total_Energy)
mQ18_server_index # 263.117
sdQ18_server_index <- sd(dataIndex_Q18$Server_Total_Energy)
sdQ18_server_index # 4.386371
sdQ18_server_index / mQ18_server_index # 0.0166708

wilcox.test(dataIndex_Q18$Juliet_Client_Total_Energy, dataBase_Q18$Juliet_Client_Total_Energy) # W = 75, p-value = 9.536e-10
wilcox.test(dataIndex_Q18$Server_Total_Energy, dataBase_Q18$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIndex_Q18$Total_Energy, dataBase_Q18$Total_Energy) # W = 1, p-value < 2.2e-16

x18_client_index <- (mQ18_client_index / mQ18_client_base) * 100
100 - x18_client_index # 39.00158

x18_server_index <- (mQ18_server_index / mQ18_server_base) * 100
100 - x18_server_index # 21.44128

# Compression Q18
dataCompression_Q18 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q18' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q18)

mQ18_client_cmp <- mean(dataCompression_Q18$Juliet_Client_Total_Energy)
mQ18_client_cmp # 23.13298
sdQ18_client_cmp <- sd(dataCompression_Q18$Juliet_Client_Total_Energy)
sdQ18_client_cmp # 1.853962
sdQ18_client_cmp / mQ18_client_cmp # 0.08014368

mQ18_server_cmp <- mean(dataCompression_Q18$Server_Total_Energy)
mQ18_server_cmp # 277.6626
sdQ18_server_cmp <- sd(dataCompression_Q18$Server_Total_Energy)
sdQ18_server_cmp # 3.13735
sdQ18_server_cmp / mQ18_server_cmp # 0.01129914

wilcox.test(dataCompression_Q18$Juliet_Client_Total_Energy, dataBase_Q18$Juliet_Client_Total_Energy) # W = 61, p-value = 1.266e-10
wilcox.test(dataCompression_Q18$Server_Total_Energy, dataBase_Q18$Server_Total_Energy) # W = 95, p-value = 1.214e-08
wilcox.test(dataCompression_Q18$Total_Energy, dataBase_Q18$Total_Energy) # W = 80, p-value = 1.863e-09

x18_client_cmp <- (mQ18_client_cmp / mQ18_client_base) * 100
100 - x18_client_cmp # 40.13697

x18_server_cmp <- (mQ18_server_cmp / mQ18_server_base) * 100
100 - x18_server_cmp # 17.09841

# Index-Compression Q18
dataIC_Q18 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q18' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q18)

mQ18_client_IC <- mean(dataIC_Q18$Juliet_Client_Total_Energy)
mQ18_client_IC # 22.88669
sdQ18_client_IC <- sd(dataIC_Q18$Juliet_Client_Total_Energy)
sdQ18_client_IC # 1.891375
sdQ18_client_IC / mQ18_client_IC # 0.08264084

mQ18_server_IC <- mean(dataIC_Q18$Server_Total_Energy)
mQ18_server_IC # 275.3858
sdQ18_server_IC <- sd(dataIC_Q18$Server_Total_Energy)
sdQ18_server_IC # 3.14229
sdQ18_server_IC / mQ18_server_IC # 0.0114105

wilcox.test(dataIC_Q18$Juliet_Client_Total_Energy, dataBase_Q18$Juliet_Client_Total_Energy) # W = 56, p-value = 5.799e-11
wilcox.test(dataIC_Q18$Server_Total_Energy, dataBase_Q18$Server_Total_Energy) # W = 49, p-value = 1.825e-11
wilcox.test(dataIC_Q18$Total_Energy, dataBase_Q18$Total_Energy) # W = 49, p-value = 1.825e-11

x18_client_IC <- (mQ18_client_IC / mQ18_client_base) * 100
100 - x18_client_IC # 40.77433

x18_server_IC <- (mQ18_server_IC / mQ18_server_base) * 100
100 - x18_server_IC # 17.77821

#### Q19 ####
# Base Q19
dataBase_Q19 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q19' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q19)

mQ19_client_base <- mean(dataBase_Q19$Juliet_Client_Total_Energy)
mQ19_client_base # 19.44865
sdQ19_client_base <- sd(dataBase_Q19$Juliet_Client_Total_Energy)
sdQ19_client_base # 2.027906
sdQ19_client_base / mQ19_client_base # 0.1042698

mQ19_server_base <- mean(dataBase_Q19$Server_Total_Energy)
mQ19_server_base # 54.96773
sdQ19_server_base <- sd(dataBase_Q19$Server_Total_Energy)
sdQ19_server_base # 1.628645
sdQ19_server_base / mQ19_server_base # 0.02962911

# Index Q19
dataIndex_Q19 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q19' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q19)

mQ19_client_index <- mean(dataIndex_Q19$Juliet_Client_Total_Energy)
mQ19_client_index # 15.84242
sdQ19_client_index <- sd(dataIndex_Q19$Juliet_Client_Total_Energy)
sdQ19_client_index # 1.234899
sdQ19_client_index / mQ19_client_index # 0.07794887

mQ19_server_index <- mean(dataIndex_Q19$Server_Total_Energy)
mQ19_server_index # 0.6825281
sdQ19_server_index <- sd(dataIndex_Q19$Server_Total_Energy)
sdQ19_server_index # 0.2827764
sdQ19_server_index / mQ19_server_index # 0.4143074

wilcox.test(dataIndex_Q19$Juliet_Client_Total_Energy, dataBase_Q19$Juliet_Client_Total_Energy) # W = 43, p-value = 6.334e-12
wilcox.test(dataIndex_Q19$Server_Total_Energy, dataBase_Q19$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIndex_Q19$Total_Energy, dataBase_Q19$Total_Energy) # W = 0, p-value < 2.2e-16

x19_client_index <- (mQ19_client_index / mQ19_client_base) * 100
100 - x19_client_index # 18.54233

x19_server_index <- (mQ19_server_index / mQ19_server_base) * 100
100 - x19_server_index # 98.75831

# Compression Q19
dataCompression_Q19 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q19' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q19)

mQ19_client_cmp <- mean(dataCompression_Q19$Juliet_Client_Total_Energy)
mQ19_client_cmp # 19.63982
sdQ19_client_cmp <- sd(dataCompression_Q19$Juliet_Client_Total_Energy)
sdQ19_client_cmp # 2.143856
sdQ19_client_cmp / mQ19_client_cmp # 0.1091586

mQ19_server_cmp <- mean(dataCompression_Q19$Server_Total_Energy)
mQ19_server_cmp # 53.75713
sdQ19_server_cmp <- sd(dataCompression_Q19$Server_Total_Energy)
sdQ19_server_cmp # 2.145882
sdQ19_server_cmp / mQ19_server_cmp # 0.03991808

wilcox.test(dataCompression_Q19$Juliet_Client_Total_Energy, dataBase_Q19$Juliet_Client_Total_Energy) # W = 476, p-value = 0.7082
wilcox.test(dataCompression_Q19$Server_Total_Energy, dataBase_Q19$Server_Total_Energy) # W = 265, p-value = 0.00577
wilcox.test(dataCompression_Q19$Total_Energy, dataBase_Q19$Total_Energy) # W = 384, p-value = 0.3354

x19_client_cmp <- (mQ19_client_cmp / mQ19_client_base) * 100
100 - x19_client_cmp # -0.9829472

x19_server_cmp <- (mQ19_server_cmp / mQ19_server_base) * 100
100 - x19_server_cmp # 2.202383

# Index-Compression Q19
dataIC_Q19 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q19' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q19)

mQ19_client_IC <- mean(dataIC_Q19$Juliet_Client_Total_Energy)
mQ19_client_IC # 15.80479
sdQ19_client_IC <- sd(dataIC_Q19$Juliet_Client_Total_Energy)
sdQ19_client_IC # 1.464589
sdQ19_client_IC / mQ19_client_IC # 0.09266744

mQ19_server_IC <- mean(dataIC_Q19$Server_Total_Energy)
mQ19_server_IC # 0.5985233
sdQ19_server_IC <- sd(dataIC_Q19$Server_Total_Energy)
sdQ19_server_IC # 0.2594059
sdQ19_server_IC / mQ19_server_IC # 0.4334099

wilcox.test(dataIC_Q19$Juliet_Client_Total_Energy, dataBase_Q19$Juliet_Client_Total_Energy) # W = 41, p-value = 4.381e-12
wilcox.test(dataIC_Q19$Server_Total_Energy, dataBase_Q19$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIC_Q19$Total_Energy, dataBase_Q19$Total_Energy) # W = 0, p-value < 2.2e-16

x19_client_IC <- (mQ19_client_IC / mQ19_client_base) * 100
100 - x19_client_IC # 18.73581

x19_server_IC <- (mQ19_server_IC / mQ19_server_base) * 100
100 - x19_server_IC # 98.91114

#### Q20 ####
# Base Q20
dataBase_Q20 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q20' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q20)

mQ20_client_base <- mean(dataBase_Q20$Juliet_Client_Total_Energy)
mQ20_client_base # 20.01527
sdQ20_client_base <- sd(dataBase_Q20$Juliet_Client_Total_Energy)
sdQ20_client_base # 2.004518
sdQ20_client_base / mQ20_client_base # 0.1001494

mQ20_server_base <- mean(dataBase_Q20$Server_Total_Energy)
mQ20_server_base # 65.59652
sdQ20_server_base <- sd(dataBase_Q20$Server_Total_Energy)
sdQ20_server_base # 4.460122
sdQ20_server_base / mQ20_server_base # 0.06799327

# Index Q20
dataIndex_Q20 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q20' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q20)

mQ20_client_index <- mean(dataIndex_Q20$Juliet_Client_Total_Energy)
mQ20_client_index # 20.554
sdQ20_client_index <- sd(dataIndex_Q20$Juliet_Client_Total_Energy)
sdQ20_client_index # 2.158123
sdQ20_client_index / mQ20_client_index # 0.1049977

mQ20_server_index <- mean(dataIndex_Q20$Server_Total_Energy)
mQ20_server_index # 60.42709
sdQ20_server_index <- sd(dataIndex_Q20$Server_Total_Energy)
sdQ20_server_index # 1.665739
sdQ20_server_index / mQ20_server_index # 0.0275661

wilcox.test(dataIndex_Q20$Juliet_Client_Total_Energy, dataBase_Q20$Juliet_Client_Total_Energy) # W = 519, p-value = 0.3136
wilcox.test(dataIndex_Q20$Server_Total_Energy, dataBase_Q20$Server_Total_Energy) # W = 99, p-value = 1.94e-08
wilcox.test(dataIndex_Q20$Total_Energy, dataBase_Q20$Total_Energy) # W = 194, p-value = 9.532e-05

x20_client_index <- (mQ20_client_index / mQ20_client_base) * 100
100 - x20_client_index # -2.691595

x20_server_index <- (mQ20_server_index / mQ20_server_base) * 100
100 - x20_server_index # 7.880642

# Compression Q20
dataCompression_Q20 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q20' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q20)

mQ20_client_cmp <- mean(dataCompression_Q20$Juliet_Client_Total_Energy)
mQ20_client_cmp # 20.82552
sdQ20_client_cmp <- sd(dataCompression_Q20$Juliet_Client_Total_Energy)
sdQ20_client_cmp # 1.465226
sdQ20_client_cmp / mQ20_client_cmp # 0.07035723

mQ20_server_cmp <- mean(dataCompression_Q20$Server_Total_Energy)
mQ20_server_cmp # 63.93755
sdQ20_server_cmp <- sd(dataCompression_Q20$Server_Total_Energy)
sdQ20_server_cmp # 4.31009
sdQ20_server_cmp / mQ20_server_cmp # 0.06741093

wilcox.test(dataCompression_Q20$Juliet_Client_Total_Energy, dataBase_Q20$Juliet_Client_Total_Energy) # W = 583, p-value = 0.04962
wilcox.test(dataCompression_Q20$Server_Total_Energy, dataBase_Q20$Server_Total_Energy) # W = 340, p-value = 0.1058
wilcox.test(dataCompression_Q20$Total_Energy, dataBase_Q20$Total_Energy) # W = 416, p-value = 0.6228

x20_client_cmp <- (mQ20_client_cmp / mQ20_client_base) * 100
100 - x20_client_cmp # -4.048125

x20_server_cmp <- (mQ20_server_cmp / mQ20_server_base) * 100
100 - x20_server_cmp # 2.529047

# Index-Compression Q20
dataIC_Q20 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q20' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q20)

mQ20_client_IC <- mean(dataIC_Q20$Juliet_Client_Total_Energy)
mQ20_client_IC # 20.67038
sdQ20_client_IC <- sd(dataIC_Q20$Juliet_Client_Total_Energy)
sdQ20_client_IC # 2.373232
sdQ20_client_IC / mQ20_client_IC # 0.1148131

mQ20_server_IC <- mean(dataIC_Q20$Server_Total_Energy)
mQ20_server_IC # 61.46489
sdQ20_server_IC <- sd(dataIC_Q20$Server_Total_Energy)
sdQ20_server_IC # 2.415334
sdQ20_server_IC / mQ20_server_IC # 0.03929615

wilcox.test(dataIC_Q20$Juliet_Client_Total_Energy, dataBase_Q20$Juliet_Client_Total_Energy) # W = 522, p-value = 0.2928
wilcox.test(dataIC_Q20$Server_Total_Energy, dataBase_Q20$Server_Total_Energy) # W = 172, p-value = 1.916e-05
wilcox.test(dataIC_Q20$Total_Energy, dataBase_Q20$Total_Energy) # W = 276, p-value = 0.009604

x20_client_IC <- (mQ20_client_IC / mQ20_client_base) * 100
100 - x20_client_IC # -3.27305

x20_server_IC <- (mQ20_server_IC / mQ20_server_base) * 100
100 - x20_server_IC # 6.298551

#### Q21 ####
# Base Q21
dataBase_Q21 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q21' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q21)

mQ21_client_base <- mean(dataBase_Q21$Juliet_Client_Total_Energy)
mQ21_client_base # 20.00078
sdQ21_client_base <- sd(dataBase_Q21$Juliet_Client_Total_Energy)
sdQ21_client_base # 2.18328
sdQ21_client_base / mQ21_client_base # 0.1091597

mQ21_server_base <- mean(dataBase_Q21$Server_Total_Energy)
mQ21_server_base # 61.87054
sdQ21_server_base <- sd(dataBase_Q21$Server_Total_Energy)
sdQ21_server_base # 1.990096
sdQ21_server_base / mQ21_server_base # 0.03216549

# Index Q21
dataIndex_Q21 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q21' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q21)

mQ21_client_index <- mean(dataIndex_Q21$Juliet_Client_Total_Energy)
mQ21_client_index # 20.01388
sdQ21_client_index <- sd(dataIndex_Q21$Juliet_Client_Total_Energy)
sdQ21_client_index # 2.175845
sdQ21_client_index / mQ21_client_index # 0.1087168

mQ21_server_index <- mean(dataIndex_Q21$Server_Total_Energy)
mQ21_server_index # 61.91295
sdQ21_server_index <- sd(dataIndex_Q21$Server_Total_Energy)
sdQ21_server_index # 1.982677
sdQ21_server_index / mQ21_server_index # 0.03202363

wilcox.test(dataIndex_Q21$Juliet_Client_Total_Energy, dataBase_Q21$Juliet_Client_Total_Energy) # W = 447, p-value = 0.9707
wilcox.test(dataIndex_Q21$Server_Total_Energy, dataBase_Q21$Server_Total_Energy) # W = 443, p-value = 0.924
wilcox.test(dataIndex_Q21$Total_Energy, dataBase_Q21$Total_Energy) # W = 442, p-value = 0.9124

x21_client_index <- (mQ21_client_index / mQ21_client_base) * 100
100 - x21_client_index # -0.06549743

x21_server_index <- (mQ20_server_index / mQ21_server_base) * 100
100 - x21_server_index # 2.333011

# Compression Q21
dataCompression_Q21 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q21' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q21)

mQ21_client_cmp <- mean(dataCompression_Q21$Juliet_Client_Total_Energy)
mQ21_client_cmp # 19.8613
sdQ21_client_cmp <- sd(dataCompression_Q21$Juliet_Client_Total_Energy)
sdQ21_client_cmp # 2.05432
sdQ21_client_cmp / mQ21_client_cmp # 0.1034333

mQ21_server_cmp <- mean(dataCompression_Q21$Server_Total_Energy)
mQ21_server_cmp # 60.31621
sdQ21_server_cmp <- sd(dataCompression_Q21$Server_Total_Energy)
sdQ21_server_cmp # 1.553521
sdQ21_server_cmp / mQ21_server_cmp # 0.02575628

wilcox.test(dataCompression_Q21$Juliet_Client_Total_Energy, dataBase_Q21$Juliet_Client_Total_Energy) # W = 433, p-value = 0.8087
wilcox.test(dataCompression_Q21$Server_Total_Energy, dataBase_Q21$Server_Total_Energy) # W = 259, p-value = 0.004313
wilcox.test(dataCompression_Q21$Total_Energy, dataBase_Q21$Total_Energy) # W = 290, p-value = 0.01759

x21_client_cmp <- (mQ21_client_cmp / mQ21_client_base) * 100
100 - x21_client_cmp # 0.697406

x21_server_cmp <- (mQ21_server_cmp / mQ21_server_base) * 100
100 - x21_server_cmp # 2.51223

# Index-Compression Q21
dataIC_Q21 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q21' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q21)

mQ21_client_IC <- mean(dataIC_Q21$Juliet_Client_Total_Energy)
mQ21_client_IC # 20.76992
sdQ21_client_IC <- sd(dataIC_Q21$Juliet_Client_Total_Energy)
sdQ21_client_IC # 1.964395
sdQ21_client_IC / mQ21_client_IC # 0.09457883

mQ21_server_IC <- mean(dataIC_Q21$Server_Total_Energy)
mQ21_server_IC # 61.66733
sdQ21_server_IC <- sd(dataIC_Q21$Server_Total_Energy)
sdQ21_server_IC # 2.397255
sdQ21_server_IC / mQ21_server_IC # 0.03887399

wilcox.test(dataIC_Q21$Juliet_Client_Total_Energy, dataBase_Q21$Juliet_Client_Total_Energy) # W = 527, p-value = 0.2601
wilcox.test(dataIC_Q21$Server_Total_Energy, dataBase_Q21$Server_Total_Energy) # W = 407, p-value = 0.5325
wilcox.test(dataIC_Q21$Total_Energy, dataBase_Q21$Total_Energy) # W = 494, p-value = 0.5229

x21_client_IC <- (mQ21_client_IC / mQ21_client_base) * 100
100 - x21_client_IC # -3.845533

x21_server_IC <- (mQ21_server_IC / mQ21_server_base) * 100
100 - x21_server_IC # 0.3284385

#### Q22 ####
# Base Q22
dataBase_Q22 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                             "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q22' and Strategy = 'base' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataBase_Q22)

mQ22_client_base <- mean(dataBase_Q22$Juliet_Client_Total_Energy)
mQ22_client_base # 119.39
sdQ22_client_base <- sd(dataBase_Q22$Juliet_Client_Total_Energy)
sdQ22_client_base # 7.183973
sdQ22_client_base / mQ22_client_base # 0.0601723

mQ22_server_base <- mean(dataBase_Q22$Server_Total_Energy)
mQ22_server_base # 4427.197
sdQ22_server_base <- sd(dataBase_Q22$Server_Total_Energy)
sdQ22_server_base # 327.209
sdQ22_server_base / mQ22_server_base # 0.07390883

# Index Q22
dataIndex_Q22 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                              "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q22' and Strategy = 'index' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIndex_Q22)

mQ22_client_index <- mean(dataIndex_Q22$Juliet_Client_Total_Energy)
mQ22_client_index # 16.21936
sdQ22_client_index <- sd(dataIndex_Q22$Juliet_Client_Total_Energy)
sdQ22_client_index # 1.100385
sdQ22_client_index / mQ22_client_index # 0.06784394

mQ22_server_index <- mean(dataIndex_Q22$Server_Total_Energy)
mQ22_server_index # 1.414598
sdQ22_server_index <- sd(dataIndex_Q22$Server_Total_Energy)
sdQ22_server_index # 0.2742176
sdQ22_server_index / mQ22_server_index # 0.1938484

wilcox.test(dataIndex_Q22$Juliet_Client_Total_Energy, dataBase_Q22$Juliet_Client_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIndex_Q22$Server_Total_Energy, dataBase_Q22$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIndex_Q22$Total_Energy, dataBase_Q22$Total_Energy) # W = 0, p-value < 2.2e-16

x22_client_index <- (mQ22_client_index / mQ22_client_base) * 100
100 - x22_client_index # 86.41482

x22_server_index <- (mQ22_server_index / mQ22_server_base) * 100
100 - x22_server_index # 99.96805

# Compression Q22
dataCompression_Q22 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                                    "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q22' and Strategy = 'compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataCompression_Q22)

mQ22_client_cmp <- mean(dataCompression_Q22$Juliet_Client_Total_Energy)
mQ22_client_cmp # 118.9296
sdQ22_client_cmp <- sd(dataCompression_Q22$Juliet_Client_Total_Energy)
sdQ22_client_cmp # 7.669
sdQ22_client_cmp / mQ22_client_cmp # 0.06448356

mQ22_server_cmp <- mean(dataCompression_Q22$Server_Total_Energy)
mQ22_server_cmp # 4387.182
sdQ22_server_cmp <- sd(dataCompression_Q22$Server_Total_Energy)
sdQ22_server_cmp # 311.391
sdQ22_server_cmp / mQ22_server_cmp # 0.07097745

wilcox.test(dataCompression_Q22$Juliet_Client_Total_Energy, dataBase_Q22$Juliet_Client_Total_Energy) # W = 389, p-value = 0.7938
wilcox.test(dataCompression_Q22$Server_Total_Energy, dataBase_Q22$Server_Total_Energy) # W = 376, p-value = 0.6402
wilcox.test(dataCompression_Q22$Total_Energy, dataBase_Q22$Total_Energy) # W = 376, p-value = 0.6402

x22_client_cmp <- (mQ22_client_cmp / mQ22_client_base) * 100
100 - x22_client_cmp # 0.3856972

x22_server_cmp <- (mQ22_server_cmp / mQ22_server_base) * 100
100 - x22_server_cmp # 0.9038467

# Index-Compression Q22
dataIC_Q22 <- read.csv.sql("~/Documents/07 Articulos/06 After Thesis/2024 ENASE/data_analysis/01-client_server_resume_iteration.csv", 
                           "select *, Juliet_Client_Total_Energy + Server_Total_Energy as 'Total_Energy' from file where Query = 'Q22' and Strategy = 'index_and_compression' and Server_Total_Energy > 0", header = TRUE, sep = ",")
head(dataIC_Q22)

mQ22_client_IC <- mean(dataIC_Q22$Juliet_Client_Total_Energy)
mQ22_client_IC # 16.26144
sdQ22_client_IC <- sd(dataIC_Q22$Juliet_Client_Total_Energy)
sdQ22_client_IC # 0.8212043
sdQ22_client_IC / mQ22_client_IC # 0.05050009

mQ22_server_IC <- mean(dataIC_Q22$Server_Total_Energy)
mQ22_server_IC # 1.198195
sdQ22_server_IC <- sd(dataIC_Q22$Server_Total_Energy)
sdQ22_server_IC # 0.2280012
sdQ22_server_IC / mQ22_server_IC # 0.1902873

wilcox.test(dataIC_Q22$Juliet_Client_Total_Energy, dataBase_Q22$Juliet_Client_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIC_Q22$Server_Total_Energy, dataBase_Q22$Server_Total_Energy) # W = 0, p-value < 2.2e-16
wilcox.test(dataIC_Q22$Total_Energy, dataBase_Q22$Total_Energy) # W = 0, p-value < 2.2e-16

x22_client_IC <- (mQ22_client_IC / mQ22_client_base) * 100
100 - x22_client_IC # 86.37956

x22_server_IC <- (mQ22_server_IC / mQ22_server_base) * 100
100 - x22_server_IC # 99.97294

#########################################
#######################################