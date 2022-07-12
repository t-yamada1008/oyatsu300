import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import '../stylesheets/application';

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import("admin-lte/node_modules/bootstrap/dist/js/bootstrap.bundle.min");
import("admin-lte/dist/js/adminlte.min");
