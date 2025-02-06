import { onSchedule } from "firebase-functions/v2/scheduler";
import * as admin from "firebase-admin";


admin.initializeApp();

exports.resetRoutinesAtMidnight = onSchedule("every day 14:24", async () => {

    const usersRef = admin.firestore().collection("users");

    const usersSnapshot = await usersRef.get();
    // Utilisation de 'for...of' pour gérer correctement les opérations asynchrones
    for (const userDoc of usersSnapshot.docs) {
        const routinesRef = usersRef.doc(userDoc.id).collection("routines");
        const routinesSnapshot = await routinesRef.where("done", "==", true).get();

        const batch = admin.firestore().batch();
        routinesSnapshot.forEach((routineDoc) => {
            batch.update(routinesRef.doc(routineDoc.id), { done: false });
        });

        await batch.commit();
    }

    console.log("Routines reset at midnight");
});
