<?php
/**
 * @file
 * bcl_captcha.features.inc
 */

/**
 * Implements hook_ctools_plugin_api().
 */
function bcl_captcha_ctools_plugin_api($module = NULL, $api = NULL) {
  if ($module == "strongarm" && $api == "strongarm") {
    return array("version" => "1");
  }
}
