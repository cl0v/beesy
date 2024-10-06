import { checkUserIsAdmin } from "@/lib/check_user_permissions";
import initializeFirebase from "@/lib/firebaseAdmin";
import { getMessaging } from 'firebase-admin/messaging';

export async function POST(request: Request) {
    const isAdm = checkUserIsAdmin(request);

    if (!isAdm) {
        return new Response(JSON.stringify({ message: "Apenas administradores podem enviar notificações." }), {
            status: 403
        })
    }

    const app = await initializeFirebase()

    const body = await request.json()

    const msgs = body.recipients.map((userId: string) => {
        return {
            notification: {
                title: body.title,
                body: body.message
            },
            data: { titulo: "Valor da mensagem, NÃO APARECE NA NOTIFICAÇÃO" },
            topic: userId
        }
    })

    const msgId = await getMessaging(app).sendEach(msgs);

    console.log('Successfully sent message:', msgId);

    if (!msgId) {
        return new Response(JSON.stringify({ message: "Falha ao enviar a mensagem" }), {
            status: 400
        })
    }

    return new Response(JSON.stringify({ message: "Push notification sent successfully." }), {
        status: 200
    });




    if (body.recipients.lenght == 0) {
        return new Response(JSON.stringify({ message: "Lista de destinatários não pode ser vazia" }), {
            status: 400
        })
    }

}
