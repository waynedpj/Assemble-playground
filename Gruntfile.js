"use strict";

module.exports = function(grunt) {
  require("load-grunt-tasks")(grunt, {
    pattern: ["grunt-*", "assemble"],
    config: "package.json",
    scope: ["devDependencies"]
  });
  require('time-grunt')(grunt);
  grunt.initConfig({
    config: {
      src: "in",
      dist: "out",
      lib: "lib",
      root: "<%= config.src %>/root",
      stage: "stage"
    },
    watch: {
      assemble: {
        files: ["<%= config.root %>/**/*.{md,html,yml,yaml}"],
        tasks: ["assemble"]
      },
      livereload: {
        options: {
          livereload: "<%= connect.options.livereload %>"
        },
        files: ["<%= config.stage %>/**/*.html", "<%= config.stage %>/assets/**/*.css", "<%= config.stage %>/assets/**/*.js", "<%= config.root %>/assets/**/*.{png,jpg,jpeg,gif,webp,svg}"]
      }
    },
    connect: {
      options: {
        port: 9000,
        livereload: 35729,
        hostname: "localhost"
      },
      livereload: {
        options: {
          open: true,
          base: ["<%= config.stage %>", "<%= config.src %>"]
        }
      }
    },
    assemble: {
      options: {
        flatten: false,
        assets: "<%= config.src %>/assets",
        layoutdir: "<%= config.src %>/templates/layouts/",
        layout: "page.html",
        data: "<%= config.src %>/**/*.{json,yml,yaml}",
        partials: "<%= config.src %>/templates/partials/**/*.html",
        helpers: ["<%= config.src %>/lib/Handlebars/helpers/**/*.js"],
        plugins: ["assemble-contrib-permalinks", "<%= config.src %>/lib/Assemble/plugins/**/*.js"],
        site: {
          title: "Assemble Playground"
        },
        fromLoDash: {
          title: "<%= title %>",
          dirname: "<%= dirname %>"
        }
      },
      root: {
        options: {
          layout: "page.html",
          permalinks: {
            slugify: true,
            structure: ":title/index.html"
          }
        },
        files: [
          {
            expand: true,
            cwd: "<%= config.root %>",
            src: ["*.html", "*.md"],
            dest: "<%= config.stage %>"
          }
        ]
      },
      pages: {
        options: {
          layout: "content.html",
          permalinks: {
            slugify: true,
            structure: ":title/index.html",
            patterns: [
              {
                pattern: /:\b(title)\b/,
                replacement: function(match) {
                  var _str;
                  _str = require("underscore.string");
                  grunt.verbose.ok("match = " + match);
                  return _str.slugify(match);
                }
              }
            ]
          }
        },
        files: [
          {
            expand: true,
            cwd: "<%= config.root %>/pages",
            src: ["**/*.html", "**/*.md"],
            dest: "<%= config.stage %>/page"
          }
        ]
      },
      releases: {
        options: {
          layout: "release.html",
          compose: {
            cwd: "./"
          },
          permalinks: {
            slugify: true,
            structure: ":title/index.html",
            patterns: [
              {
                pattern: ":title",
                replacement: "<%= dirname %>"
              }
            ]
          }
        },
        files: [
          {
            expand: true,
            cwd: "<%= config.root %>/releases",
            src: ["*/*.html"],
            dest: "<%= config.stage %>/release"
          }
        ]
      },
      tracks: {
        options: {
          layout: "track.html",
          compose: {
            cwd: "./"
          },
          permalinks: {
            slugify: true,
            structure: ":title/index.html"
          }
        },
        files: [
          {
            expand: true,
            cwd: "<%= config.root %>/releases/",
            src: ["*/tracks/**/*.html"],
            dest: "<%= config.stage %>/"
          }
        ]
      }
    },
    jsbeautifier: {
      options: {
        html: {
          maxPreserveNewlines: 0,
          preserveNewlines: true,
          wrapLineLength: 0
        },
        css: {},
        js: {}
      },
      stage: {
        src: "<%= config.stage %>/**/*"
      }
    },
    clean: ["<%= config.stage %>/**/*"]
  });
  grunt.registerTask("serve", ["clean", "assemble", "connect:livereload", "watch"]);
  grunt.registerTask("build", ["clean", "assemble", "jsbeautifier"]);
  grunt.registerTask("default", ["build"]);
};
