import os, subprocess

application_properties_location = "projects/collector/src/main/resources/application.properties"
collector_dir = "projects/collector"

def set_application_properties(config):
    print("Setting Collector Properties...")
    collector_config = config["collector"]
    db_host = collector_config["db_host"]
    db_port = collector_config["db_port"]
    db_user = collector_config["db_user"]
    db_password = collector_config["db_password"]
    port = collector_config["port"]
    application_properties = [
        "spring.application.name=collector",
        "spring.datasource.url=jdbc:postgresql://{}:{}/collector".format(db_host, db_port),
        "spring.datasource.username={}".format(db_user),
        "spring.datasource.password={}".format(db_password),
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect",
        "server.port={}".format(port)
    ]
    
    with open(application_properties_location, "w") as f:
        f.writelines(line + "\n" for line in application_properties)


def build():
    print("Preparing Collector...")
    make_process = subprocess.run(["mvn", "clean", "install", "-DskipTests", "package" ], 
                     cwd=collector_dir, 
                     capture_output=True )
    if make_process.returncode != 0:
        print("Error building collector")

def prepare_resources(config):
    set_application_properties(config)
    build()

def start(config):
    collector_jar = "projects/collector/target/collector-0.0.1-SNAPSHOT.jar"
    proc = subprocess.Popen([config["consoleCommand"], "--", "java", "-jar", 
                            collector_jar ],
                        cwd="./")
    return proc