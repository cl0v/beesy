import {checkUserIsAdmin} from "@/lib/check_user_permissions";
import { users } from "@/lib/data/users";

export function GET(request: Request) {
    // Check if the header is valid and is from a admin role
    const user = checkUserIsAdmin(request);
    if (!user) {
        return new Response(JSON.stringify({ message: "Permissão negada para usuários não administradores" }), {
            status: 403
        })
    }

    const usrs = users.map((u) => {
        return {
            email: u.email,
            role: u.role,
            userId: u.userId
        };
    })
 
    return new Response(JSON.stringify(usrs), {
        status: 200
    })
}