export async function GET(request: Request) {
    // IGNORE
    if (request.headers.get("Authorization") === "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1bmlxdWVfdXNlcl9pZCIsIm5hbWUiOiJNYXJjZWxvIFZpYW5hIiwicm9sZSI6InVzZXIiLCJpYXQiOjE1MTYyMzkwMjJ9.M-11Q55zotA-wt0QuScCcR2HVMbcSceceqS4ITtsji4") {
        return new Response(JSON.stringify({
            userId: "unique_user_id",
            email: "user@example.com",
            role: "user" // ou "admin"
        }), {
            status: 200
        }
            ,)
    } else if (request.headers.get("Authorization") === "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1bmlxdWVfYWRtaW5faWQiLCJuYW1lIjoiQWRtaW4gRmVybmFuZGVzIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNTE2MjM5MDIyfQ.MeyG2Z3Zq19jCYhmIUABwKA63VRCh9y-bNAiaRrGyQo") {
        return new Response(JSON.stringify({
            userId: "unique_admin_id",
            email: "admin@example.com",
            role: "admin" // ou "admin"
        }), {
            status: 200
        }
            ,)
    }
    return new Response(JSON.stringify({ message: "Usuário não autorizado" }), {
        status: 401
    })
}