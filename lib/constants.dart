import 'dart:io';

import 'package:fetch_voice_data/firebase/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';

File? voiceFile;

class Constants {
  static const double height = 926;
  static const double width = 428;

  static const Map<VoiceState, List<String>> imagesUrls = {
    VoiceState.angry: [
      "https://i1.wp.com/popbee.com/image/2020/02/https-hypebeast.com-image-2020-02-apples-i0s-13-4-new-memoji-eye-roll-surprise-anger-5.jpg?quality=95&",
      "https://pbs.twimg.com/media/EFPvS7uVAAARa0s.jpg",
      "https://img.wattpad.com/2002e72c7fbddf17a32f920f443f24378f616490/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f776174747061642d6d656469612d736572766963652f53746f7279496d6167652f475f6374375245396e6946346e673d3d2d3835393539393734362e313630323366376534643762626630393438343032343934383635362e6a7067?s=fit&w=720&h=720",
    ],
    VoiceState.happy: [
      "http://andc-scale.livewallcampaigns.com/imageScaled/scale?site=andc&w=1200&h=630&cropped=1&file=1537355257_animoji-header.jpg",
      "https://cdn131.picsart.com/318342880280201.jpg?type=webp&to=crop&r=256",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcrE0PW5HgoZSUsvbReIhaTG51xFGKfGcCBQ&usqp=CAU",
    ],
    VoiceState.sad: [
      "https://i.pinimg.com/564x/1d/90/44/1d90444c8e8c35bff0bf6c717ca7f302.jpg",
      "https://images1.vinted.net/t/01_00e19_gDwu3f5jawhQpkteZRk21nEw/1598465177.jpeg?s=a0e885fe37255b6790de2abe734f3b8807b01f6a",
      // "https://i.pinimg.com/236x/f1/7b/22/f17b2266af62722d15ef339822e94afe.jpg",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTw0N1dBbRYiCa2DMs8UK8QH2TSmFtqqBGOgw&usqp=CAU",
    ],
    VoiceState.disgust: [
      "https://i2-prod.dailystar.co.uk/incoming/article21485347.ece/ALTERNATES/s1200c/0_Eye-Roll-Memoji.jpg",
      // "https://ih1.redbubble.net/image.1940530006.0097/st,small,507x507-pad,600x600,f8f8f8.u1.jpg",
      "https://s3.tradingview.com/userpics/5938085-fBpW_orig.png",
      "https://i.pinimg.com/236x/8f/b2/cc/8fb2ccfca070beb6a9fb336793a95b92.jpg",
    ],
    VoiceState.surprised: [
      "https://pbs.twimg.com/media/DoG4WcKWsAEgT1g.jpg",
      "https://i.pinimg.com/originals/d8/69/66/d86966ce8d5c7e12cfc40b18da788d1b.jpg",
      "https://i.pinimg.com/236x/56/4e/c3/564ec376a7ef3e9980caf84171610607.jpg",
    ],
    VoiceState.fear: [
      "https://www.thurrott.com/wp-content/uploads/sites/2/2019/02/memoji.jpg",
      "https://i.pinimg.com/236x/cf/d3/d6/cfd3d684c645186edef709e4ccd144eb.jpg",
      // "https://static.wikia.nocookie.net/59b8082d-9d77-49a5-8b30-097b954b77d8/scale-to-width/755",
      "https://d38we5ntdyxyje.cloudfront.net/1327961/profile/ZANPJRBL_avatar_medium_square.jpg",
    ],
    VoiceState.neutral: [
      "https://i.pinimg.com/originals/b3/5c/13/b35c134d14561a75a2be6c63ca317c42.jpg",
      "https://avatars.githubusercontent.com/u/34377510?v=4",
      "https://play-lh.googleusercontent.com/a-/AOh14Gj5D_Rb727H855q78cygC_apXnjOKN0PBH7fEJ4SA",
    ],
    VoiceState.pensive: [
      "https://i.pinimg.com/originals/55/7a/ee/557aee3ce530f6ae193cdb08a384ad3c.jpg",
      "https://avatars.githubusercontent.com/u/13198813?v=4",
      "https://pbs.twimg.com/profile_images/1190372854031945728/eRihpPDg_400x400.jpg",
      "https://i.pinimg.com/236x/70/cf/b5/70cfb537c502f0ec56adb9da04c2fc08.jpg",
    ],
    VoiceState.funny: [
      "https://www.macobserver.com/wp-content/uploads/2019/09/workfeatured-iOS-13-memoji.png",
      "https://i.pinimg.com/originals/2d/9c/f1/2d9cf10d9a21f2c704b3c64f5b838705.jpg",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuRFfele_vg7i8e9nijAS-gtBH0BPYLlvEDlZaqAufda-BCtxU4CAbJ1DXGrdR3VJ9_HY&usqp=CAU",
    ],
    VoiceState.illuminated: [
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqpzJjw7GvSYJKfGCh7ZcRqd6phJmLpAJVsZuKfDyJUgz7CJv_BA0TPxp4JEPsrxbnnyM&usqp=CAU",
      // "https://i.pinimg.com/474x/ea/13/de/ea13def1ad0f24b3ed8cd70f3a768bdc.jpg",
      "https://i.pinimg.com/236x/b6/ab/7b/b6ab7bfc2e0a7c1cc86af7165625e69d.jpg",
      "https://pbs.twimg.com/profile_images/1177649029934669824/WHKgU9Ny_400x400.jpg",
    ],
    VoiceState.love: [
      "https://i.pinimg.com/236x/cd/54/e2/cd54e2c49d2d97916a50ce431f4b83db.jpg",
      // "https://i.pinimg.com/originals/cb/b1/6a/cbb16ae4f765a5cbeac8dd20f4899ae4.png",
      "https://i.pinimg.com/736x/7c/c5/d5/7cc5d5b0699fd63b73078101eaa47480.jpg",
      "https://pbs.twimg.com/media/EHulVlEWsAEwTFA.jpg",
    ],
  };

  static const Map<VoiceState, List<String>> textAssociatedToState = {
    VoiceState.angry: [
      "Calme toi putain !",
      "Putain, tu casses les couilles.",
      "Roooooh, j'en peux plus ça fait une heure que je suis dessus.",
      "Bon okay okay je me calme.",
      "Bon aller ça suffit, je me casse.",
      "Ça fait une heure que je suis sur cet exo je comprends rien."
    ],
    VoiceState.happy: [
      "Oh je suis tellement content(e), faut que je te raconte le truc qui vient de m'arriver.",
      "T'as pas idée à quel point ça me fait plaisir que tu viennes ce soir",
      "J'étais enchanté(e) de te voir tout à l'heure, c'était un trop bon moment",
      "La session de surf était tellement bien tout à l'heure, il y avait des bonnes vagues, du soleil, tout était parfait !"
    ],
    VoiceState.sad: [
      "Je l'aimais tellement, je suis si triste.",
      "Parfois je sais même plus ce que je fais, rien n'a plus aucun sens.",
      "Ca fait plusieurs mois que je ne parle plus avec mon père.",
      "J'ai encore raté mes concours, qu'est ce que je vais faire maintenant.",
    ],
    VoiceState.disgust: [
      "Arrrgh, c'est dégueulasse ce que je mange, ce plat est repoussant.",
      "Plus jamais je m'impliquerai comme ça, vu ce que ça a donné.",
      "Ah oui tu es sérieux ? je suis déçu. Tu fais ça dans mon dos en plus.",
      "Tu sais pas qui j'ai croisé tout à l'heure !!!"
    ],
    VoiceState.surprised: [
      "Bah pourquoi tu le prends comme ça, il n'y a rien de méchant.",
      "C'est pas vrai ! tu lui as vraiment dit ça ?",
      "Mais nan, jure..."
    ],
    VoiceState.fear: [
      "Faut que je te raconte, il y a un gars super bizarre qui m'a suivi hier soir en rentrant, j'ai eu super peur.",
      "Jamais je passe par là, il fait sombre, il y a des gens bizarre qui traînent en plus.",
      "J'ai cru que j'allais mourir, il conduisait n'importe comment. Il m'a fait trop peur."
    ],
    VoiceState.neutral: [
      "Ouais pourquoi pas, c'est vrai que ça peut être sympa.",
      "On dîne ensemble tout à l'heure ? Tu veux venir à la maison ?",
      "J'arrive dans 5 min, je suis dans la rue d'à côté",
      "Il y aura qui à la soirée ?",
      "Je t'attends à la sortie du métro. Ça te va ?",
    ],
    VoiceState.pensive: [
      "Je me demande bien ce qu'il peut être en train de faire.",
      "Tu penses que ça va si je m'habille comme ça pour ce soir ?",
      "Tu sais si c'est bon le restaurant où on va ce soir ou pas. Je ne sais pas si ça va me plaire.",
      "Est-ce que tu crois que je le prends ou pas ?",
    ],
    VoiceState.funny: [
      "Il m'est arrivé un truc tellement drôle tout à l'heure, faut que je te raconte.",
      "Hahahah, tu mens ! Y'avait vraiment un nain dans le four ?",
      "Je viens de regarder The Interview, c'était excellent !",
    ],
    VoiceState.illuminated: [
      "Oh je viens d'avoir une idée de fou, écoute moi bien c'est le futur !",
      "Ah mais j'ai compriiiis ! Enfin !",
      "Oh c'est bon, je l'ai, j'ai trouvé !"
    ],
    VoiceState.love: [
      "Je t'aime tellement. Tu es tout pour moi.",
      "Si tu as un problème, appelle moi, surtout n'hésite pas, je serai là.",
      "On peut aller dîner ensemble au restaurant puis aller au cinéma après si tu veux.",
      "Je kiffe être célibataire mais je t'avoue que j'aimerais bien que quelqu'un me sert dans les bras."
    ],
  };

  static const Map<VoiceState, Color> voiceColor = {
    VoiceState.angry: Color(0xffeb4d4b),
    VoiceState.happy: Color(0xffffbe76),
    VoiceState.sad: Color(0xff95afc0),
    VoiceState.disgust: Color(0xff30336b),
    VoiceState.surprised: Color(0xff7ed6df),
    VoiceState.fear: Color(0xff95afc0),
    VoiceState.neutral: Color(0xff686de0),
    VoiceState.pensive: Color(0xffbadc58),
    VoiceState.funny: Color(0xfff0932b),
    VoiceState.illuminated: Color(0xfff6e58d),
    VoiceState.love: Color(0xffff7979),
  };
}







// Laugh
