import { checkUserToken } from "@/lib/check_user_permissions"

export function GET(request: Request) {
    const user = checkUserToken(request)

    if (!user) {
        return new Response(JSON.stringify({ message: "Apenas o usuário autenticado pode acessar suas próprias notificações." }), {
            status: 403
        })
    }

    return new Response(JSON.stringify(user?.notifications), {
        status: 200
    })
}