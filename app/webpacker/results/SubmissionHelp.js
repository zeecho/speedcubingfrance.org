import React from 'react';

const SubmissionHelp = () => (
  <>
    <h5>Comment entrer ses temps ?</h5>
    <div className="text-justify">
      Vous pouvez envoyer, corriger, ou supprimer votre participation tant que la compétition est en cours.
      Les temps doivent être entrés, sans point, deux-points ni virgules, le logiciel fera le reste.
      Par exemple :
      <ul>
        <li>2 secondes 54 centièmes : tapez « 254 »</li>
        <li>1 minute 23 secondes 12 centièmes : tapez « 12312 »</li>
      </ul>
      Attention : n’oubliez jamais les centièmes !<br/>
      Pénalités :
      <ul>
        <li>En cas de +2, entrez directement le résultat final. Par exemple : Si vous avez terminé votre cube en 6 secondes 45 et avez une pénalité de +2, entrez directement 8 secondes 45 soit « 845 ».</li>
        <li>En cas de DNF, écrivez « D » dans la case -En cas de DNS, écrivez « S » dans la case.</li>
      </ul>
      <p>
        Pour le multiblind, la première case correspond au nombre de cubes résolus, la seconde au nombre de cubes tentés, la dernière au temps au format minutes secondes centièmes.
        <br/>
        Par exemple : 5 / 7 en 47 minutes et 12 secondes : entrez 5 dans la première case, 7 dans la seconde et « 471200 » dans la dernière.
      </p>

      <p>
        Cela vous plait ? Bonne nouvelle, c'est exactement comme ça que nous rentrons les temps lors des compétitions officielles !
        N'hésitez pas à venir proposer votre aide à la saisie des temps lors de la prochaine compétition ;)
      </p>
    </div>
  </>
);

export default SubmissionHelp;
