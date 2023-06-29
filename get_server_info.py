import requests
import platform

def get_server_info(url):
    try:
        response = requests.get(url)
        server_info = {
            'IP Address': response.headers.get('X-Forwarded-For', None),
            'Operating System': platform.system(),
            'Server': response.headers.get('Server', None)
        }
        return server_info
    except requests.exceptions.RequestException as e:
        print(f"Error occurred: {str(e)}")
        return None

def main():
    url = input("Enter the URL of the website: ")
    server_info = get_server_info(url)
    if server_info:
        print("Server Information:")
        for key, value in server_info.items():
            print(f"{key}: {value}")
    else:
        print("Failed to retrieve server information.")

if __name__ == "__main__":
    main()
