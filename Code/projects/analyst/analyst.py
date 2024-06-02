import socket
import json

def send_message(selected_socket, message):
    print("Sending: " + message)
    selected_socket.send((message + '\n').encode())
    print("Waiting reception code")
    rec = selected_socket.recv(1).decode()
    if(rec == "0"):
        return True
    return False


def receive_message(ssocket):
    print("Receiving Message")
    message = ssocket.recv(1024).decode()
    print("Sending confirmation code")
    status = ssocket.send(("0" + '\n').encode())
    return message

def close(socket):
    print("Closing connection")
    if(send_message(socket, "9")):
        socket.close()
        print("OK")
        return
    print("Error closing connection")


def create_sockets(config):
    successfully_listening_orchestrators = []
    sockets = []
    orchestrators = config["orchestrators"].values()
    orchestrators_names = list(config["orchestrators"].keys())
    for orq_name, orq in zip(orchestrators_names, orchestrators):
        try:
            print("Connecting to Orchestrator " + orq_name + "...")
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect((orq["address"], int(orq["port"])))
            sockets.append(s)
            successfully_listening_orchestrators.append(orq_name)
        except socket.error as err: 
            print ("socket creation failed with error %s" %(err))
    return successfully_listening_orchestrators, sockets


def select_orchestrator(orchestrators):
    if(len(orchestrators) == 0):
        print("There is not available orchestrators")
        exit()
    print("Select orchestrator")
    for i, name in enumerate(orchestrators):
        print("{}) {}".format(i, name))
    return int(input(">> "))

def get_options(ssocket):
    try:
        return json.loads(receive_message(ssocket))["options"]
    except:
        print("Error Getting Options")

def select_option(options):
    if(len(options) == 0):
        print("No available options in orchestrator")
        return
    print("Available options")
    for i, opt in enumerate(options):
        print("{}) {}".format(i, opt["label"]))
    return options[int(input("> "))]

def talk(ssocket: socket):
    options = get_options(ssocket)
    option = select_option(options)
    close(ssocket)

def send_option(ssocket, option):
    print("Sending option: " + option["label"])
    return send_message(ssocket, option["key"])

def open(config):
    orchestrators, sockets = create_sockets(config)
    option_indx = select_orchestrator(orchestrators)
    selected_socket = sockets[option_indx]
    options = get_options(selected_socket)
    option = select_option(options)
    if(send_option(selected_socket, option)):
        print("Option Sended")
    else:
        print("Error Sending Option")

    input("")
    # close(selected_socket)


