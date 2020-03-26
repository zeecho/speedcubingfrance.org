import React, { Fragment, useState } from 'react';

import Alert from 'react-bootstrap/Alert';

import I18n from 'i18n-for-js';

const NotSignedIn = () => (
  <Alert variant="info">
    {I18n.t("general.please_sign_in")}
  </Alert>
);

export default NotSignedIn;
