// Por fins de praticidade, não irei criar um token toda vez que uma sessão for iniciada.
// Se preferir essa funcionalidade, basta ler a doc do NextAuth.js

export const users = [
    {
        token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1bmlxdWVfdXNlcl9pZCIsIm5hbWUiOiJNYXJjZWxvIFZpYW5hIiwicm9sZSI6InVzZXIiLCJpYXQiOjE1MTYyMzkwMjJ9.M-11Q55zotA-wt0QuScCcR2HVMbcSceceqS4ITtsji4",
        userId: "unique_user_id",
        email: "user@example.com",
        password: "$2b$10$Oz5NXgx.JkaMl0V2IPva6eFCWd8Y6h5jnQUE.GnkLl4tGAQ1K9NkC",
        role: "user",
        notifications: [
            {
                "notificationId": "notification_id",
                "title": "Título da notificação",
                "message": "Corpo da mensagem",
                "timestamp": "2023-09-28T12:34:56Z"
            },
            {
                "notificationId": "notification_id2",
                "title": "Título da notificação2",
                "message": "Corpo da mensagem2",
                "timestamp": "2023-09-29T12:34:56Z"
            }
        ]
    },
    {
        token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1bmlxdWVfYWRtaW5faWQiLCJuYW1lIjoiQWRtaW4gRmVybmFuZGVzIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNTE2MjM5MDIyfQ.MeyG2Z3Zq19jCYhmIUABwKA63VRCh9y-bNAiaRrGyQo",
        userId: "unique_admin_id",
        email: "admin@example.com",
        password: "$2b$10$RjbPVLzB8GAcaFYcAHld.eUtGnv44KJknh2cK99nmGU6OEbZrDIiq",
        role: "admin",
        notifications: [
            {
                "notificationId": "notification_id",
                "title": "Título da notificação",
                "message": "Corpo da mensagem",
                "timestamp": "2023-09-28T12:34:56Z"
            }
        ]
    }
];