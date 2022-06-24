import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import '../stylesheets/application';

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require("admin-lte");
