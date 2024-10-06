"use server"

import admin from 'firebase-admin';
import { cert, initializeApp } from 'firebase-admin/app';
import serviceAccount from '@/serviceAccountKey.json';

export default async function initializeFirebase() {
    if (admin.apps.length > 0) {
        return admin.app()
    }

    return initializeApp(
        {
            credential: cert(serviceAccount as admin.ServiceAccount)
        }
    );

}
