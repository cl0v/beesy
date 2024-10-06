export async function POST() {
    // Não irei fazer o 401 Unauthorized. Pois ainda nem fiz o sistema de notificações
    // Agradeço a compreenção
    return new Response(JSON.stringify({ message: "Logout successful" }), {
        status: 200
    })
}