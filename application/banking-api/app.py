
from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import os
import pymssql


class BankingAPI(BaseHTTPRequestHandler):

    def respond(self, status, data):
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

    def do_GET(self):

        if self.path == "/health":
            self.respond(200, {
                "status": "healthy",
                "service": "mavendale-banking-api"
            })

        elif self.path == "/db-health":
            try:
                with pymssql.connect(
                    server=os.environ["SQL_SERVER"],
                    user=os.environ["SQL_USER"],
                    password=os.environ["SQL_PASSWORD"],
                    database=os.environ["SQL_DATABASE"],
                    login_timeout=5,
                    timeout=5
                ) as conn:
                    with conn.cursor() as cursor:
                        cursor.execute("SELECT 1")
                        result = cursor.fetchone()[0]

                self.respond(200, {
                    "status": "healthy",
                    "database": "connected",
                    "query_result": result
                })

            except Exception:
                self.respond(503, {
                    "status": "unhealthy",
                    "database": "unavailable"
                })

        else:
            self.send_error(404, "Endpoint not found")


if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8080), BankingAPI)
    print("Mavendale Banking API listening on port 8080")
    server.serve_forever()
