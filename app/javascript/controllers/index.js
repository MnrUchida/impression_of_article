// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import FormController from "./form_controller.js"
application.register("form", FormController)

import CopyController from "./copy_controller.js"
application.register("copy", CopyController)

import InputCountController from "./input_count_controller.js"
application.register("input-count", InputCountController)

import ModalController from "./modal_controller.js"
application.register("modal", ModalController)

import MultipleSelectModalController from "./multiple_select_modal_controller.js"
application.register("multiple-select-modal", MultipleSelectModalController)
