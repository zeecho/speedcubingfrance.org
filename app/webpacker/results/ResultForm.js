import React, { useState, useEffect, useRef } from 'react';
import { loadableComponent } from 'requests/loadable';
import { loadResultUrl } from 'requests/routes';
import formats from 'wca/formats';
import { times, trimTrailingZeros } from 'wca/utils';
import { best, average } from 'wca/stats';
import { useKeyNavigation } from 'wca-live/navigation';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Spinner from 'react-bootstrap/Spinner';
import Button from 'react-bootstrap/Button';
import isEqual from 'lodash/isEqual';

import AttemptList from './AttemptList';
import { ErrorList } from 'requests/Lists';

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

const ResultForm = ({
  id,
  originalResult,
  saving,
  saveState,
  userData
}) => {
  const [attempts, setAttempts] = useState([]);
  const [savedResult, setSavedResult] = useState(originalResult);
  const [errors, setErrors] = useState([]);
  const [initFocus, setInitFocus] = useState(false);
  const rootRef = useRef(null);
  const eventId = id.eventId
  const competitionId = id.competitionId
  const solveCount = originalResult.format_id ?
    formats.byId[originalResult.format_id].expected_solve_count : 0;

  const resetState = res => {
    setErrors([]);
    setAttempts(
      times(solveCount, index =>
        (res.attempts && res.attempts[index]) || 0)
    );
    setSavedResult(res);
    setInitFocus(false);
  };

  useEffect(() => {
    if (!rootRef.current) return;
    if (initFocus) return;
    const firstAttemptInput = rootRef.current.getElementsByTagName('input')[0];
    if (!firstAttemptInput) return;
    setInitFocus(true);
    setTimeout(() => {
      firstAttemptInput.focus();
      firstAttemptInput.select();
    }, 0);
  });

  useEffect(() => {
    resetState(originalResult);
  }, [originalResult]);

  const toRequestData = clear => {
    const resAttempts = clear ? [0, 0, 0, 0, 0] : attempts;
    const res = {
      best: best(resAttempts),
      average: average(resAttempts, eventId, solveCount),
      attempts: resAttempts,
    }
    resAttempts.map((a, index) => res[`value${index+1}`] = a);
    return {
      competition_id: competitionId,
      event_id: eventId,
      result: res,
    };
  };

  useKeyNavigation(rootRef.current);

  const hasChanges = () => {
    return !isEqual(trimTrailingZeros(savedResult.attempts), trimTrailingZeros(attempts));
  };

  const mayDelete = () => {
    return trimTrailingZeros(savedResult.attempts).length !== 0;
  };

  const saveResult = clear => {
    const res = toRequestData(clear);
    const newSaved = {
      ...savedResult,
      best: res.result.best,
      average: res.result.average,
      attempts: res.result.attempts,
    };
    saveState(res, response => {
      if (response.errors) {
        setErrors(response.errors);
      } else {
        resetState(newSaved);
      }
    });
  };

  return (
    <>
      <Row ref={rootRef}>
        <Col xs={12} md={6} className="mb-3">
          <AttemptList
            attempts={attempts}
            setAttempts={setAttempts}
            eventId={eventId}
            savedResult={savedResult}
            solveCount={solveCount}
          />
          <div className="mt-3">
          <div className="d-flex justify-content-center mb-2">
            <Button size="lg"
              variant="outline-success"
              className="mr-3"
              disabled={!hasChanges() || saving}
              onClick={() => saveResult(false)}
            >
              {saving ? (
                <Spinner role="status" animation="border">
                  <span className="sr-only">Saving...</span>
                </Spinner>
              ) : (
                <>Sauvegarder</>
              )}
            </Button>
            <Button size="lg"
              variant="outline-danger"
              disabled={!mayDelete() || saving}
              onClick={() => saveResult(true)}
            >
              {saving ? (
                <Spinner role="status" animation="border">
                  <span className="sr-only">Saving...</span>
                </Spinner>
              ) : (
                <>Supprimer</>
              )}
            </Button>
          </div>
          <p className="font-weight-bold">
            Pensez à sauvegarder avant de changer d'épreuve
          </p>
          {errors.length > 0 && (
            <div className="text-left">
              <ErrorList items={errors} />
            </div>
          )}
          </div>

        </Col>
        <Col xs={12} md={6} className="text-center d-flex flex-column">
          <SubmissionHelp />
        </Col>
      </Row>
    </>
  );
};

export default ResultForm;
