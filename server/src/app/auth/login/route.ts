import bcrypt from 'bcrypt';
import { users } from '@/lib/data/users'

export async function POST(request: Request) {
    const body = await request.formData()
    const email = body.get('email')?.toString()
    const password = body.get('password')?.toString()

    if (!email || !password) return new Response(JSON.stringify({ message: "Email and password are required" }), {
        status: 400
    })

    const idx = users.map(function (e) { return e.email; }).indexOf(email);
    if (idx == -1) {
        return new Response(JSON.stringify({ message: "Usuário não encontrado" }), {
            status: 401
        })
    }

    const passwordsMatch = await bcrypt.compare(password, users[idx].password);

    if (passwordsMatch) {
        const usr = users[idx]
        return new Response(JSON.stringify({
            token: usr.token,
            userId: usr.userId,
            role: usr.role,
        }
        ), {
            status: 200
        })
    }

    return new Response(JSON.stringify({ message: "Credenciais inválidas" }), {
        status: 401
    })
}
