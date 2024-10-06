import { checkUserIsAdmin } from "@/lib/check_user_permissions"
import { users } from "@/lib/data/users";

export async function PATCH(request: Request, { params }: { params: { userId: string } }){

    const usr = checkUserIsAdmin(request)
    if (!usr) {
        return new Response(JSON.stringify({ message: "Apenas administradores podem fazer essa requisição." }), {
            status: 403
        })
    }

    const body = await request.json()
    
    const id = params.userId;
    const idx = users.map(function (e) { return e.userId; }).indexOf(id.toString());

    users[idx].role = body.role

    return new Response(JSON.stringify({ message: "Role updated successfully" }), {
        status: 200
    })
}