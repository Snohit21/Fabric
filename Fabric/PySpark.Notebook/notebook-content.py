# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {}
# META }

# CELL ********************

data  = [
    (1, "Rahul" , "IT" , 60000),
    (2, "Priya" , "HR" , 75000),
    (3, "Amit" , "IT" , 40000),
    (4, "Sneha" , "Finance" , 69000),
    (5, "Ravi" , "IT" , 80000),
    (6, "Ravuri" , "HR" , 40000),
    (7, "Linda" , "Finance" , 55000)
]

Columns = ["id","Emp_Name","Department","Salary"]

df = spark.createDataFrame(data,Columns)

df.show()


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

df.printSchema()

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

df.select("salary","Emp_Name").show()

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

df.filter(f.col("Salary")>=50000).show()

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
