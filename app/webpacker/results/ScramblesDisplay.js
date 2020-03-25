import React, { useState } from 'react';

import Card from 'react-bootstrap/Card';

const LongScramblesList = ({
  scramblesData
}) => (
  <pre>
    {scramblesData.scrambles.map((s, index) => {
      return (
        <div key={index}>
          Essai {index + 1}<br/>
          {s}
          <hr/>
        </div>
      );
    })}
    {scramblesData.extras.map((s, index) => {
      return (
        <div key={index}>
          Extra {index + 1}<br/>
          {s}
          <hr/>
        </div>
      );
    })}
  </pre>
);

const ScramblesDisplay = ({
  eventId,
  scramblesData
}) => {
  const [expanded, setExpanded] = useState(false);
  const headerAction = ev => {
    ev.preventDefault();
    ;
  };
  return (
    <Card className="scrambles-card">
      <Card.Header onClick={() => setExpanded(!expanded)} className="text-center">
        Afficher les mélanges de l'épreuve (pour les importer dans une application comme cstimer)
      </Card.Header>
      {expanded && (
        <Card.Body>
          {(eventId === "333mbf" || eventId === "minx") ? (
            <LongScramblesList scramblesData={scramblesData} />
          ) : (
            <pre>
            {scramblesData.scrambles.join("\n")}
            <br/>Extras:<br/>
            {scramblesData.extras.join("\n")}
            </pre>
          )}
        </Card.Body>
      )}
    </Card>
  );
};

export default ScramblesDisplay;
