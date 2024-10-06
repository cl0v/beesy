import { users } from "@/lib/data/users";
import bcrypt from 'bcrypt';

export async function PATCH(request: Request, { params }: { params: { userId: string } }) {
    const id = params.userId;



    if (!id) return new Response(JSON.stringify({ message: "User id was not provided" }), {
        status: 400
    })

    const body = await request.formData()
    const idx = users.map(function (e) { return e.userId; }).indexOf(id.toString());

    if (body.get('oldPassword')?.toString() === "" || body.get('newPassword')?.toString() === "" ) return new Response(JSON.stringify({ message: "Password is required" }), {
        status: 400
    })


    if (idx === -1) return new Response(JSON.stringify({ message: "User not found" }), {
        status: 404
    })

    const passwordsMatch = await bcrypt.compare(body.get('oldPassword')!.toString(), users[idx].password)

    if (!passwordsMatch) return new Response(JSON.stringify({ message: "Old password is not correct" }), {
        status: 400
    })


    users[idx].password = await bcrypt.hash(body.get('newPassword')!.toString(), 10);

    return new Response(JSON.stringify({ message: "Password updated successfully" }), {
        status: 200
    })
}