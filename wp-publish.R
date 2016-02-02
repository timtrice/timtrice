#' wpPublish
#'
#' See https://codex.wordpress.org/XML-RPC_MetaWeblog_API for additional details
#' https://codex.wordpress.org/XML-RPC_WordPress_API/Categories_%26_Tags
#' Sample header of a markdown file:
#' 
#' ---
#' title: Drafts and Super Bowl Quarterbacks
#' description: The Quick Red Fox Jumps Over The Lazy Brown Dog. The Quick Red Fox Jumps Over The Lazy Brown Dog. 
#' post_type: post
#' categories: Sports, Football
#' mt_keywords: football, super bowl
#' wp_slug: drafted-super-bowl-quarterbacks
#' wp_author_display_name: timtrice
#' ---
#' 
#' The "---" strings are not required but good for readability.
#' 
#' @param ext character file extension of the markdown
#' @param edit boolean TRUE if editing a post
#' @param publish boolean TRUE if the post should be published
#' @param post_type character c("post", "page")
#' @param wp_author_display_name character author's display name. See WordPress Profile
#'
#' @todo add editing functionality
#' @todo connect to dataframe to store post info OR connect to MySQL
#' @todo description doesn't push through. 
#' @todo allow some meta to push through as defaults rather than header
#' 



wpPublish <- function(ext = "*.Rmd", edit = FALSE, publish = FALSE, 
                      post_type = "post", wp_author_display_name = "timtrice") {
    
    getTag <- function(infile, c, tag) {
        
        extract_tag <- grep(tag, contents, value = TRUE)
        
        if(length(extract_tag) == 0) {
            warning(sprintf("No %s tag present in %s", tag, infile))
            return (NULL)
        }
        
        tag <- sub(paste(tag, "[ :]+(.)", sep = ""), "\\1", extract_tag)
        
        return(tag)
    }
    
    publishPost <- function(file, rmd, meta) {
        
        require(RWordPress)
        
        source("../wordpress.R", local = TRUE)
        
        options(WordpressLogin = c(timtrice = wppw),
                WordpressURL = "http://timtrice.co/xmlrpc.php")
        
        require(knitr)
        require(markdown)
        opts_knit$set(upload.fun = function(file){
            library(RWordPress) 
            uploadFile(file)$url
        })
        opts_knit$set(unnamed.chunk.label = meta$wp_slug)
        opts_chunk$set(fig.cap = "center")
        
        post_id <- knit2wp(file, title = trimws(meta$title), 
                           categories = trimws(meta$categories[[1]]), 
                           description = trimws(meta$description), 
                           mt_keywords = trimws(meta$mt_keywords[[1]]), 
                           post_type = trimws(post_type), 
                           wp_author_display_name = trimws(wp_author_display_name), 
                           action = "newPost", publish = publish, 
                           shortcode = FALSE)
        
        return (post_id)
        
    }
    
    current_wd <- getwd()
    
    setwd("./")
    
    for (infile in list.files(".", pattern = ext, full.names = TRUE, 
                              recursive = TRUE)) {
        
        # Get the file directory and file name w/ extension        
        file_dir <- strsplit(infile, "/")
        file_name <- file_dir[[1]][[length(file_dir[[1]])]]
        
        # Open file and get content, close file
        con <- file(infile)
        open(con)
        contents <- readLines(con)
        close(con)
        
        # If draft == TRUE, go to next post
        draft <- getTag(infile, contents, "draft")
        if(draft == TRUE || is.null(draft)) next
        
        title <- getTag(infile, contents, "title")
        description <- getTag(infile, contents, "description")
        post_type <- getTag(infile, contents, "post_type")        
        categories <- getTag(infile, contents, "categories")
        categories <- strsplit(categories, ",")
        mt_keywords <- getTag(infile, contents, "mt_keywords")
        mt_keywords <- strsplit(mt_keywords, ",")
        wp_slug <- getTag(infile, contents, "wp_slug")
        wp_author_display_name <- getTag(infile, contents, 
                                         "wp_author_display_name")
        
        meta <- list("title" = title, 
                     "description" = description, 
                     "post_type" = post_type, 
                     "categories" = categories, 
                     "mt_keywords" = mt_keywords, 
                     "wp_slug" = wp_slug, 
                     "wp_author_display_name" = wp_author_display_name)
        
        # Check if post already exists
        if(!exists("posts")) posts <- read.csv("./data/posts.csv")
        
        require("dplyr")
        
        post_id <- posts %>% filter(file_name == file_name) %>% 
            select(post_id)
        
        # Post already exists but edit is FALSE; can't work.
        if(nrow(post_id) == 1 & edit == FALSE) {
            warning(paste(file_name, 
                          "already exists with this file name;", 
                          "Edit is FALSE. Ignoring."), 
                    sep = " ")
            next
        } else if(nrow(post_id) > 1) {
            # Uh oh
            warning(paste("Too many posts with", file_name, sep = " "))
            next
        } else if(nrow(post_id) == 0) {
            # New post
            post_id <- publishPost(file = infile, rmd = infile, meta = meta)
            if(post_id == 401) {
                warning("Not published. User does not have permission.")
            } else if(post_id == 404) {
                warning("Not published. Invalid post format.")
            } else { 
                message("Page/Post Published")
                newPosts <- data.frame(post_id = post_id[1], 
                                       file_name = file_name)
                posts <- rbind(posts, newPosts)
                write.csv(posts, "./data/posts.csv", row.names = FALSE)
                message("Posts DF updated!")
            }
        } else if(nrow(post_id) == 1 & edit == TRUE) {
            # Edit post
        }
        
    }
    
}