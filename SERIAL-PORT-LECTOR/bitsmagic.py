import serial
import requests
import time
from multiprocessing import Process, Queue

def parse_data(line):
    try:
        if line.startswith("Received packet: "):
            line = line.replace("Received packet: ", "", 1)
        parts = line.split(',')
        if len(parts) == 15:
            mission_time = parts[1]
            seconds = float(mission_time.split(':')[2])
            return {
                "altitude": seconds,
                # Asumir resto de valores procesados correctamente
            }
        else:
            print("Error parsing data")
            return None
    except ValueError as e:
        print("Error converting values:", e)
        return None

def enviar_datos(data_queue):
    while True:
        data = data_queue.get()
        if data is None:
            break
        try:
            response = requests.post('https://api-endpoint', json=data)
            print("API response:", response.json())
        except Exception as err:
            print("Error sending data:", err)

def leer_serial(data_queue):
    puerto_serial = '/dev/tty.usbserial-56440049711'
    tasa_baudios = 9600
    with serial.Serial(puerto_serial, tasa_baudios, timeout=1) as ser:
        while True:
            if ser.in_waiting > 0:
                line = ser.readline().decode('utf-8').strip()
                parsed_data = parse_data(line)
                if parsed_data:
                    data_queue.put(parsed_data)

def main():
    data_queue = Queue()
    p1 = Process(target=leer_serial, args=(data_queue,))
    p2 = Process(target=enviar_datos, args=(data_queue,))
    p1.start()
    p2.start()
    p1.join()
    p2.join()

if __name__ == "__main__":
    main()
