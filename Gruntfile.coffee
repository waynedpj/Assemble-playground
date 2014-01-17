#
# * Generated on 2014-01-05
# * generator-assemble v0.4.5
# * https://github.com/assemble/generator-assemble
# *
# * Copyright (c) 2014 Hariadi Hinta
# * Licensed under the MIT license.

"use strict"

module.exports = (grunt) ->

    # Load grunt tasks automatically front package.json
    require("load-grunt-tasks") grunt,
        pattern: ["grunt-*", "assemble"]
        config: "package.json"
        scope: ["devDependencies"]

    require('time-grunt')(grunt)
  
    # Project configuration.
    grunt.initConfig
        config:
            src: "in"
            dist: "out"
            lib: "lib"
            root: "<%= config.src %>/root"
            stage: "stage"

    
        # guarda
        watch:
            assemble:
                files: ["<%= config.root %>/**/*.{md,html,yml,yaml}"]
                tasks: ["assemble"]

            livereload:
                options:
                    livereload: "<%= connect.options.livereload %>"
                files: [
                    "<%= config.stage %>/**/*.html"
                    "<%= config.stage %>/assets/**/*.css"
                    "<%= config.stage %>/assets/**/*.js"
                    "<%= config.root %>/assets/**/*.{png,jpg,jpeg,gif,webp,svg}"
                    ]
        #
        connect:
            options:
                port: 9000
                livereload: 35729
            
                # change this to '0.0.0.0' to access the server from outside
                hostname: "localhost"

            livereload:
                options:
                    open: true
                    base: ["<%= config.stage %>", "<%= config.src %>"]
        
        # A
        assemble:
          
            # default options
            options:
                flatten: false
                assets: "<%= config.src %>/assets"
                layoutdir: "<%= config.src %>/templates/layouts/"
                layout: "page.html"
                data: "<%= config.src %>/**/*.{json,yml,yaml}"
                partials: "<%= config.src %>/templates/partials/**/*.html"
                helpers: ["<%= config.src %>/lib/Handlebars/helpers/**/*.js"]
                plugins: [
                    "assemble-contrib-permalinks"
                    "<%= config.src %>/lib/Assemble/plugins/**/*.js"
                    ]
                site:
                    title: "Assemble Playground"

                # data for testing LoDash templates
                fromLoDash:
                    title: "<%= title %>"
                    dirname: "<%= dirname %>"
          
            # root
            root:
                options:
                    layout: "page.html"
                    permalinks:
                        slugify: true
                        structure: ":title/index.html"
                files: [
                    expand: true # Enable dynamic expansion.
                    cwd: "<%= config.root %>" # Src matches are relative to this path.
                    src: ["*.html", "*.md"] # Actual pattern(s) to match.
                    dest: "<%= config.stage %>" # Destination path prefix.
                    ]

            # the 'pages' collection
            pages:
                options:
                    layout: "content.html"
                    permalinks:
                        slugify: true
                        structure: ":title/index.html"
                        patterns: [
                            pattern: /:\b(title)\b/
                            replacement: (match) ->
                                _str = require "underscore.string"
                                grunt.verbose.ok "match = " + match
                                _str.slugify match
                            ]
                files: [
                    expand: true # Enable dynamic expansion.
                    cwd: "<%= config.root %>/pages" # Src matches are relative to this path.
                    src: ["**/*.html", "**/*.md"] # Actual pattern(s) to match.
                    dest: "<%= config.stage %>/page" # Destination path prefix.
                    ]

            # the 'releases' collection
            releases:
                options:
                    layout: "release.html"
                    compose:
                        cwd: "./"
                    permalinks:
                        slugify: true
                        structure: ":title/index.html"
                        patterns: [
                            pattern: ":title"
                            replacement: "<%= dirname %>"
                            ]
                files: [
                    expand: true # Enable dynamic expansion.
                    cwd: "<%= config.root %>/releases" # Src matches are relative to this path.
                    src: ["*/*.html"] # Actual pattern(s) to match.
                    dest: "<%= config.stage %>/release" # Destination path prefix.
                    ]

            # the 'tracks' collection
            # TODO currently all tracks are grouped in same collection, need per release "tracks" collection
            tracks:
                options:
                    layout: "track.html"
                    compose:
                        cwd: "./"
                    permalinks:
                        slugify: true
                        structure: ":title/index.html"
                files: [
                    expand: true # Enable dynamic expansion.
                    cwd: "<%= config.root %>/releases/" # Src matches are relative to this path.
                    src: ["*/tracks/**/*.html"] # Actual pattern(s) to match.
                    dest: "<%= config.stage %>/" # Destination path prefix.
                    ]

        # clean up generated sources in stage
        jsbeautifier:
            options:
                html:
                    maxPreserveNewlines: 0
                    preserveNewlines: true
                    wrapLineLength: 0
                css: {}
                js: {}
            stage:
                src: "<%= config.stage %>/**/*"

        
        # Before generating any new files,
        # remove any previously-created files.
        clean: ["<%= config.stage %>/**/*"]

    grunt.registerTask "serve", ["clean", "assemble", "connect:livereload", "watch"]
    grunt.registerTask "build", ["clean", "assemble", "jsbeautifier"]
    grunt.registerTask "default", ["build"]
