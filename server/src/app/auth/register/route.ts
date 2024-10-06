import { users } from "@/lib/data/users"
import bcrypt from 'bcrypt';


export async function POST(request: Request) {
    const body = await request.formData()
    const email = body.get('email')?.toString()
    const password = body.get('password')?.toString()

    if (!email || !password) return new Response(JSON.stringify({ message: "Email and password are required" }), {
        status: 400
    })

    if (email === "already-in-use@email.com" || users.some((e) => e.email === email)) {
        return new Response(JSON.stringify({ message:  "Dados de entrada inválidos ou email já cadastrado" }), {
            status: 400
        })
    }

    const uuid = uuidv4();

    users.push({
        userId: uuid, //Ignore this please
        email: email,
        password: await bcrypt.hash(password,10),
        role: "user",
        token: await bcrypt.hash(password, 16), //Ignore this please
    })

    return new Response(JSON.stringify({ message: "User registered successfully", userId: "blabla" }), {
        status: 201
    })
}

function uuidv4() {
    return "10000000-1000-4000-8000-100000000000".replace(/[018]/g, c =>
      (+c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> +c / 4).toString(16)
    );
  }