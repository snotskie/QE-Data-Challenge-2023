#!/usr/bin/env ./scripts/helpers/node_launch.sh

// imports
const express = require('express');
const fs = require('fs');
const app = express();
const sqrl = require("squirrelly");
const Marp = require('@marp-team/marp-core');
const slide_converter = new Marp.Marp({"html": true});
const ExtraMath = require("mathjs");
const path = require('path');
require("./helpers/sqrl-filters.js");

// Configure express
app.use(express.static('public'));
app.engine(".html", sqrl.__express);

// Load Themes
const theme_files = fs.readdirSync(process.cwd() + "/themes");
for (const filename of theme_files){
  const theme_data = fs.readFileSync(process.cwd() + "/themes/" + filename, "utf-8");
  slide_converter.themeSet.add(theme_data);
}

// Scan for pages
let pages = {
  "index.md": ""
};

const page_files = fs.readdirSync(process.cwd() + "/pages");
for (const filename of page_files){
  if (typeof(pages[filename]) === "undefined"){
    pages[filename] = path.parse(filename).name;
  }
}

// Serve the pages
for (const [filename, shortname] of Object.entries(pages)) {
  app.get("/" + shortname, function(request, response){
    const report_md = fs.readFileSync(process.cwd() + `/pages/${filename}`, "utf-8");
    const results_data = JSON.parse(fs.readFileSync(process.cwd() + "/data/output/results.json", 'utf-8'));
    const rendered_md = sqrl.render(report_md, {
      title: shortname,
      results: results_data,
      nav: pages
    });
    
    const slides = slide_converter.render(rendered_md);
    response.render("page.html", {
      title: shortname,
      body: slides.html,
      style: slides.css
    });
  });
}

// go time!
const listener = app.listen(8888, function(){
  console.log('Your app is listening on port ' + listener.address().port);
});