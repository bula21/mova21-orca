import React from 'react';
import {
  withStyles,
  CircularProgress
} from '@material-ui/core';
import { compose } from 'react-recompose';

const styles = theme => ({
    loadingBar: {
        position: "fixed",
        top: theme.spacing(10),
        fontSize: 100,
        marginTop: theme.spacing(10),
        marginLeft: '30%'
    }
});

const LoadingBar = ({ classes }) => (
    <div className={ classes.root }>
    <CircularProgress className={ classes.loadingBar } size={ 100 }/>
  </div>
);

export default compose(
  withStyles(styles),
)(LoadingBar);