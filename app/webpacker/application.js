// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import jQuery from 'jquery';
import Turbolinks from 'turbolinks';
import Rails from '@rails/ujs'
import Sortable from 'sortablejs';
import { Tooltip } from 'bootstrap';
import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

import * as Sentry from "@sentry/browser";
Sentry.init(window.sentryConfig);
require.context('./images', true);
window.Sentry = Sentry;

Rails.start();
Turbolinks.start();
window.$ = jQuery;

window.Stimulus = Application.start()
const context = require.context("./controllers", true, /\.js$/)
Stimulus.load(definitionsFromContext(context))

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
// Support component names relative to this directory:
var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);


document.addEventListener("turbolinks:load", () => {
  for (const el of document.getElementsByClassName('sortable-list')) {
    setupDragSort(el);
  }
  for (const el of document.querySelectorAll('[data-onchange-submit]')) {
    el.addEventListener('change', (ev) => ev.currentTarget.form.submit());
  }
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new Tooltip(tooltipTriggerEl)
  })
});

function setupDragSort(el) {
  const mitigateError = () => { window.location.reload() }
  if (!el) return;

  Sortable.create(el, {
    onEnd: (event) => {
      fetch(event.item.dataset.sortCallbackUrl, {
        body: JSON.stringify({ index: event.newIndex }),
        method: 'PATCH',
        redirect: 'manual',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name=csrf-token]').content,
        }
      }).then((response => response.status == 204 || mitigateError()), mitigateError)
        .catch(mitigateError)
    }
  });
}
