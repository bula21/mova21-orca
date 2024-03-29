// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import CampFilterController from "./filter_controller.js"
import NumericalityController from "./numericality_controller.js"

application.register("camp-filter", CampFilterController)
application.register("numericality", NumericalityController)
