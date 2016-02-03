#' wpPublish
#'
#' See https://codex.wordpress.org/XML-RPC_MetaWeblog_API for additional details
#' https://codex.wordpress.org/XML-RPC_WordPress_API/Categories_%26_Tags
#' Sample header of a markdown file:
#' 
#' ---
#' wp_title: Drafts and Super Bowl Quarterbacks
#' wp_description: The Quick Red Fox Jumps Over The Lazy Brown Dog. The Quick Red Fox Jumps Over The Lazy Brown Dog. 
#' wp_post_type: post
#' wp_categories: Sports, Football
#' wp_mt_keywords: football, super bowl
#' wp_slug: drafted-super-bowl-quarterbacks
#' wp_author_display_name: timtrice
#' draft: TRUE
#' ---
#' 
#' The "---" strings are not required but good for readability.
#' 
#' When editing articles, only the content can be edited per the WP XML-RPC API. 
#' To change the categories or tags, it must be done through the admin panel.
#' 
#' wp_slug is the permalink of the article. If not set in the header of the  
#' markdown, it will default to the filename. 
#' 
#' At this time, figures cannot be updated and I do not see any documentation on 
#' this in the API. 
#' 
#' @param ext character file extension of the markdown
#' @param edit boolean TRUE if editing a post
#' @param publish boolean TRUE if the post should be published
#' @param post_type character c("post", "page")
#' @param wp_author_display_name character author's display name. See WordPress Profile
#'
#' @todo description doesn't push through. 
#' @todo allow some meta to push through as defaults rather than header
#' 

wpPublish <- function(ext = "\\.[R]?md", # Extension of markdown files
                      publish = FALSE,  # TRUE if want WP to publish post; 
                      # otherwise, uploaded as draft
                      post_type = "post", # post or page
                      author = "timtrice", 
                      shortcode = FALSE) { # Use [shortcode] instead of <pre>
    
    getArticle <- function(infile) {
        con <- file(infile)
        open(con)
        article <- readLines(con)
        close(con)
        return(article)
    }
    
    getTag <- function(infile = NULL, article = NULL, tag = NULL) {
        
        if(any(is.null(infile), is.null(article), is.null(tag))) 
            stop("One or more parameter is NULL.")
        
        extract_tag <- grep(tag, article, value = TRUE)
        
        if(length(extract_tag) == 0) {
            return (NULL)
        }
        
        tag <- sub(paste(tag, "[ :]+(.)", sep = ""), "\\1", extract_tag)
        
        return(tag)
    } # End getTag
    
    getMeta <- function(infile = NULL, article = NULL) {
        
        if(any(is.null(infile), is.null(article))) 
            stop("One or more parameter is NULL.")
        
        meta <- list("wp_title" = getTag(infile, article, "wp_title"), 
                     "wp_description" = getTag(infile, article, 
                                               "wp_description"), 
                     "wp_post_type" = getTag(infile, article, 
                                             "wp_post_type"), 
                     "wp_categories" = getTag(infile, article, 
                                              "wp_categories"), 
                     "wp_mt_keywords" = getTag(infile, article, 
                                               "wp_mt_keywords"), 
                     "wp_slug" = getTag(infile, article, "wp_slug"), 
                     "wp_author" = getTag(infile, article, "wp_author"))
        
        return(meta)
    }
    
    doPublish <- function(infile) { 
        
        require(lubridate)
        
        article <- getArticle(infile)
        
        # If article is localDraft or wp_draft tag not set, skip
        localDraft <- getTag(infile, article, "wp_draft")
        if(is.null(localDraft)) { 
            message(sprintf("%s not posted. No draft tag present.", infile))
            return(NULL)
        } else if(as.logical(localDraft)) { 
            message(sprintf("%s not posted. wp_draft == TRUE", infile))
            return(NULL)
        }
        
        # At this point localDraft == TRUE
        
        # import posts
        if(!exists("posts")) posts <- read.csv("./data/posts.csv", 
                                               stringsAsFactors = FALSE)
        require("dplyr")
        post <- posts %>% 
            filter(file_name == infile) %>% 
            select(post_id, mtime)
        
        # Does post already exist?
        if(nrow(post) == 0 || nrow(post) == 1) {
            
            # Get post meta
            # If file has not been modified since post$mtime, next
            if(nrow(post) == 1)
                if(post$mtime == file.info(infile)$mtime) 
                    return(NULL)
            
            meta <- getMeta(infile, article)
            
            # Clean and trim wp_categories
            if(length(meta$wp_categories) > 0) {
                meta$wp_categories <- unlist(strsplit(meta$wp_categories, 
                                                      ","))
                meta$wp_categories <- unlist(lapply(meta$wp_categories, 
                                                    FUN = trimws))
            }
            
            # Clean and trim wp_mt_keywords
            if(length(meta$wp_mt_keywords) > 0) {
                meta$wp_mt_keywords <- unlist(strsplit(meta$wp_mt_keywords, 
                                                       ","))
                meta$wp_mt_keywords <- unlist(lapply(meta$wp_mt_keywords, 
                                                     FUN = trimws))
            }
            
            # If categories and tags exist, send warning but continue
            if(is.null(meta$wp_categories)) 
                warning(sprintf(paste("No categories in %s.", 
                                      "Update this via the WP Admin Panel", 
                                      sep = " "), 
                                infile))
            
            if(is.null(meta$wp_mt_keywords)) 
                warning(sprintf(paste("No keywords(tags) in %s.", 
                                      "Update this via the WP Admin Panel", 
                                      sep = " "), 
                                infile))
            
            # If wp_slug doesn't exist, use filename
            if(length(meta$wp_slug) == 0) 
                meta$wp_slug = sub(paste0("(.)", ext), "\\1", basename(infile))
            
            # If wp_author doesn't exist, use author param
            if(length(meta$wp_author) == 0) meta$wp_author = author
            
            # At this point we're ready to start uploading
            require(RWordPress)
            
            source("../wordpress.R", local = TRUE)
            
            options(WordpressLogin = c(timtrice = wppw),
                    WordpressURL = "http://timtrice.co/xmlrpc.php")
            
            require(knitr)
            require(markdown)
            opts_knit$set(unnamed.chunk.label = meta$wp_slug)
            opts_chunk$set(fig.cap = "center")
            
            opts_knit$set(upload.fun = function(file){
                uploadFile(file)$url
            })
            
            if(nrow(post) == 0) {
                
                # Publishing a new post
                return_code <- knit2wp(infile, 
                                       title = meta$wp_title, 
                                       categories = meta$wp_categories,  
                                       description = meta$wp_description, 
                                       mt_keywords = meta$wp_mt_keywords, 
                                       post_type = meta$wp_post_type, 
                                       wp_author_display_name = meta$wp_author, 
                                       shortcode = shortcode, 
                                       action = "editPost", 
                                       postid = post$post_id, 
                                       publish = publish)
                
                if(return_code == 401) {
                    warning(paste("Error 401: User does not have permission", 
                                  "to write/edit this post.", sep = " "))
                    return(NULL)
                } else if(return_code == 404) {
                    warning("Error 404: Invalid post format specified")
                    return(NULL)
                }
                
                
                message(sprintf("%s uploaded", basename(infile)))
                newPosts <- data.frame(post_id = return_code[1], 
                                       file_name = infile, 
                                       mtime = ymd_hms(file.info(infile)$mtime))
                posts <- rbind(posts, newPosts)
                
            } else {
                
                # Editing an existing post
                # Categories and tags cannot be updated . See WP XML-RPC docs
                
                return_code <- knit2wp(infile, 
                                       title = meta$wp_title, 
                                       shortcode = shortcode, 
                                       action = "editPost", 
                                       postid = post$post_id, 
                                       publish = publish)
                
                if(return_code == 401) {
                    warning(paste("Error 401: User does not have permission", 
                                  "to write/edit this post."))
                    return(NULL)
                } else if(return_code == 404) {
                    warning(paste("Error 404: Invalid post format specified", 
                                  "or postid does not exist.", sep = " "))
                    return(NULL)
                }
                
                message(sprintf("%s updated", basename(infile)))
                posts[posts$post_id == post$post_id]$mtime <- ymd_hms(file.info(infile)$mtime)
                message("ok")
                
            }
            
            write.csv(posts, "./data/posts.csv", row.names = FALSE)
            rm(posts)
            message(sprintf("%s uploaded successfully!", basename(infile)))
            
        } else {
            # Problem
            stop("Too many posts!")
        }
        
    } # End doPublish
    
    infile <- list.files(".", pattern = ext, full.names = TRUE, 
                         recursive = TRUE)
    
    code <- lapply(infile, FUN = doPublish)
    
}

