#!/usr/bin/env python3

import json

def main():
    result = {
        "id": "some-id",
        #"description": "some description"
    }
    print(json.dumps(result))  # Ensure valid JSON output

if __name__ == "__main__":  
    main()
