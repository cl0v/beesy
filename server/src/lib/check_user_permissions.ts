import { users } from "./data/users";

export  function checkUserToken(request: Request) {
    const jwt = request.headers.get("Authorization")?.split(" ")[1];
    const idx = users.map((e) => e.token).indexOf(jwt?.toString() || "-1");

    if (idx === -1) return null

    return users[idx];
}

export function checkUserIsAdmin(request: Request) {
    const user = checkUserToken(request)
    if (!user) return false
    return user.role === "admin"
}
