# IfSimply User
ifsimply_user               = User.new
ifsimply_user.id            = 1
ifsimply_user.name          = "Keith Griffis"
ifsimply_user.email         = "keith.griffis@gmail.com"
ifsimply_user.password      = "testing1"
ifsimply_user.description   = "Tell the IfSimply community about yourself. We want to know your hopes and dreams. Click " +
                              "here to change it. To change your photo, drag and drop a new one from your desktop"
ifsimply_user.icon          = Settings.users[:default_icon]
ifsimply_user.payment_email = Settings.paypal[:account_email]
ifsimply_user.verified      = true
ifsimply_user.save

# Confirm the IfSimply User
ifsimply_user.confirm!

# IfSimply Club
ifsimply_club             = ifsimply_user.clubs.first
ifsimply_club.id          = 1
ifsimply_club.name        = "Membership Club Secrets"
ifsimply_club.sub_heading = "How to Build & Grow a Successful Club"
ifsimply_club.description = "Want to create a profitable and successful membership club? We will teach you how to get " +
                            "up and running fast, the essential elements of a club, and take you step by step through " +
                            "the process of building a successful club."
ifsimply_club.price       = "40.00"
ifsimply_club.save

# IfSimply Sales Page
ifsimply_sales                = ifsimply_club.sales_page
ifsimply_sales.heading        = "Build & Grow a Profitable Membership Club"
ifsimply_sales.sub_heading    = "Learn our best membership club secrets"
ifsimply_sales.video          = "http://youtu.be/zHfjpuWAWCE"
ifsimply_sales.call_to_action = "Become an Insider"
ifsimply_sales.call_details   = "Join the club to access exclusive courses, articles and discussions that are members only. " +
                                "This is the good stuff that we only share with our favorite people like you!<div><br>"       +
                                "</div><div>Join for free now and get access right away!</div><div></div>"
ifsimply_sales.benefit1       = "Learn the essential elements of a successful membership club"
ifsimply_sales.benefit2       = "How to create your own video courses easily and for free"
ifsimply_sales.benefit3       = "The one key thing you can do to keep people coming back monthly"
ifsimply_sales.details        = "<div>I want you to reach your full potential. We created IfSimply.com to help people turn "    +
                                "their knowledge and passion into a profitable online business. We turned to membership sites " +
                                "because they are an honest and valuable way to monetize your knowledge.&nbsp;</div><div><br>"  +
                                "</div><div>Creating your own membership club has never been easier. This club is dedicated "   +
                                "to showing you how. We take you step-by-step through creating articles, engaging in "          +
                                "discussion, and creating your own video courses.&nbsp;</div><div><br></div><div>This is "      +
                                "information people spend thousands to get, but we are giving it away for free. We want you "   +
                                "to create your club on IfSimply.com and start focusing on your content and members, not the "  +
                                "technical stuff.</div><div style=\"text-align: right;\"><br></div><div style=\"text-align: "   +
                                "right;\">So Join now and Make it Happen!&nbsp;</div><div style=\"text-align: right;\"><br>"    +
                                "</div><div style=\"text-align: right;\">Go be Great!</div><div style=\"text-align: right;\">"  +
                                "-Keith Griffis&nbsp;</div><div style=\"text-align: right;\">Co-founder, IfSimply.com</div>"    +
                                "<div></div>"
ifsimply_sales.about_owner    = "<p><i>Keith Griffis is the co-founder of IfSimply.com and an internationally known marketer " +
                                "and new media educator. He has taught marketing courses&nbsp;at Massachusetts Institute of "  +
                                "Technology (MIT), Salem State University, and colleges throughout the United States. He is "  +
                                "an author and technology entrepreneur trying to shape the way people use new media.</i></p>"  +
                                "<div><i>He is known for helping people discover their passion and turn it into a profitable " +
                                "online business.</i></div>"
ifsimply_sales.save

# IfSimply Upsell Page
ifsimply_upsell                         = ifsimply_club.upsell_page
ifsimply_upsell.heading                 = "Want to get WAY more out of this club?"
ifsimply_upsell.sub_heading             = "Sign up for a Pro Membership!"
ifsimply_upsell.basic_articles_desc     = "How-to articles that will keep you up to date and on the cutting edge."
ifsimply_upsell.exclusive_articles_desc = "These are premium in-depth articles and tutorials that only Pro Members can access."
ifsimply_upsell.basic_courses_desc      = "Our courses will guide you with video, give you actionable lessons, and come with " +
                                          "downloadable reference materials."
ifsimply_upsell.in_depth_courses_desc   = "Our premium courses dig deep to teach you what matters. This is content you " +
                                          "definitely won't get anywhere else."
ifsimply_upsell.discussion_forums_desc  = "Community is a crucial part of the growth process. Connect with folks just like " +
                                          "you to learn, share, and grow."
ifsimply_upsell.save

# IfSimply Discussion Board
ifsimply_discussion             = ifsimply_club.discussion_board
ifsimply_discussion.name        = "Membership Club Secrets Discussion"
ifsimply_discussion.description = "This is where you can get all those answers you want. Ask about how to use ifSimply.com " +
                                  "or general membership club questions."
ifsimply_discussion.save

# IfSimply Topics
ifsimply_topic             = ifsimply_discussion.topics.new
ifsimply_topic.user_id     = ifsimply_user.id
ifsimply_topic.subject     = "Tell Us About Yourself!"
ifsimply_topic.description = "We want to hear about who you are. Tell us about yourself, your business, and what you " +
                             "want to get out of this club?"
ifsimply_topic.save

# IfSimply Articles
ifsimply_article         = ifsimply_club.articles.new
ifsimply_article.free    = true
ifsimply_article.image   = "/assets/start_your_club.png"
ifsimply_article.title   = "Getting Started with Your Article Area"
ifsimply_article.content = "<p><font color=\"#000000\">Getting started with your article area is simple. You will want " +
                           "to replace this with your own text.&nbsp;If you have existing articles (or blog posts) you " +
                           "can copy and paste the text here. To start writing from scratch, just type it in here and "  +
                           "hit Save above when done. To see a preview of how it will look to your members, click "      +
                           "preview in the gray bar above.&nbsp;</font></p><p><font color=\"#000000\"><br></font></p>"   +
                           "<h4 style=\"text-align: center;\"><font color=\"#000000\"><b><u><span class=\"large-bold\">" +
                           "Here are some quick tips about using your article area:</span></u></b></font></h4><p style=" +
                           "\"text-align: center;\"><br></p><p><b><u>To change any formatting of text use the gray "     +
                           "formatting bar above.</u></b></p><p><img src=\"/assets/article_start.png\"><br></p><p>"      +
                           "<br></p><p><b><u></u><span class=\"large-bold\"><u>To add an image, just drag and drop it "  +
                           "into this text area or drag it&nbsp;over the logo to change it.&nbsp;</u></span></b></p><p>" +
                           "<img src=\"/assets/image_demo.png\"></p><p><br></p><b><u>Save Your Changes by Clicking "     +
                           "\"Save\" in the Gray Editor Bar at the top of the screen.</u></b><div><img src=\"/assets/"   +
                           "formatting_bar.png\" align=\"middle\"></div><div><br></div><div><br></div><div>To add a "    +
                           "new Article, go to your \"Article\"&nbsp;link (in your club navigation) and choose \"Add "   +
                           "New\":</div><div><img src=\"/assets/start_article.png\"><br></div>"
ifsimply_article.save

# IfSimply - Courses 1
ifsimply_course1             = ifsimply_club.courses.new
ifsimply_course1.logo        = "/assets/get_started_course.png"
ifsimply_course1.title       = "Introduction to IfSimply"
ifsimply_course1.description = "This is a quick introduction to IfSimply.com to get you familiar with the setup of the " +
                               "site, how to run your club, and give you the lay of the land."
ifsimply_course1.save

# IfSimply - Course 1 Lesson 1
ifsimply_course1_lesson1                 = ifsimply_course1.lessons.new
ifsimply_course1_lesson1.title           = "Lesson 1 - Your Club Home Page & Navigation"
ifsimply_course1_lesson1.free            = true
ifsimply_course1_lesson1.video           = "http://youtu.be/zHfjpuWAWCE"
ifsimply_course1_lesson1.background      = "This video take you through your club home page"
ifsimply_course1_lesson1.save

# IfSimply - Course 1 Lesson 2
ifsimply_course1_lesson2                 = ifsimply_course1.lessons.new
ifsimply_course1_lesson2.title           = "Lesson 2 - Getting to Know Your Article Area"
ifsimply_course1_lesson2.free            = true
ifsimply_course1_lesson2.background      = "This takes you through the article area of your club.<div><br></div><div>" +
                                           "<u>Key Take-aways from this lesson:</u></div><div><ol><li>How to add an "  +
                                           "article</li><li>Drag &amp; drop images</li><li>Type over existing text"    +
                                           "</li></ol></div>"
ifsimply_course1_lesson2.save

# IfSimply - Course 1 Lesson 3
ifsimply_course1_lesson3                 = ifsimply_course1.lessons.new
ifsimply_course1_lesson3.title           = "Lesson 3 - How to Use Your Discussion Area"
ifsimply_course1_lesson3.free            = true
ifsimply_course1_lesson3.background      = "This is lesson goes through your discussion area.<div><br></div><div><u>"  +
                                           "Key Take-aways from this lesson:</u></div><div><ol><li>Only paid members " +
                                           "of your club&nbsp;can post new topics</li><li>All members can reply to "   +
                                           "topics</li><li>how to create new topics and strategies to engage your "    +
                                           "members</li></ol></div>"
ifsimply_course1_lesson3.save

# IfSimply - Course 1 Lesson 4
ifsimply_course1_lesson4                 = ifsimply_course1.lessons.new
ifsimply_course1_lesson4.title           = "Lesson 4 - Sales Page and Upsell Page"
ifsimply_course1_lesson4.free            = true
ifsimply_course1_lesson4.background      = "This shows you your sales page.<div><br></div><div><u>Key Take-aways from "  +
                                           "this lesson:</u></div><div><ol><li>What is a sales page&nbsp;</li><li>What " +
                                           "is an upsell page</li><li>How to edit your sales page &amp; upsell</li><li>" +
                                           "How to promote your club using your sales page</li><li>How to verify your "  +
                                           "club and make your club live</li></ol></div>"
ifsimply_course1_lesson4.save

# IfSimply - Course 1 Lesson 5
ifsimply_course1_lesson5                 = ifsimply_course1.lessons.new
ifsimply_course1_lesson5.title           = "Lesson 5 - Admin Page"
ifsimply_course1_lesson5.free            = false
ifsimply_course1_lesson5.background      = "This lesson gives you a quick tour of your Club Admin page.<div><br></div>"  +
                                           "<div><u>In this lesson you will learn:</u></div><div><ol><li>How to verify " +
                                           "your club</li><li>How to promote your club link</li><li></li></ol></div>"
ifsimply_course1_lesson5.save

# IfSimply - Course 2
ifsimply_course2             = ifsimply_club.courses.new
ifsimply_course2.logo        = "/assets/default_initial_course_logo.jpg"
ifsimply_course2.title       = "Crafting Your First Course"
ifsimply_course2.description = "How to create a course that sells, fast! This course takes you through the steps to "      +
                               "conceive, outline, produce, and launch your first online course. We simplified dozens of " +
                               "tools, tips, and knowledge into an easy to follow and simple course on courses!"
ifsimply_course2.save

# IfSimply - Course 2 Lesson 1
ifsimply_course2_lesson1                 = ifsimply_course2.lessons.new
ifsimply_course2_lesson1.title           = "Lesson 1 - Why Video & Choosing a Topic"
ifsimply_course2_lesson1.free            = true
ifsimply_course1_lesson1.video           = "http://youtu.be/Q-1m5HJZVUM"
ifsimply_course2_lesson1.background      = "<div>Video courses are the most impactful for a few reasons. This video takes " +
                                           "you through those reasons, how to find your target market, and how to find a "  +
                                           "topic.<br></div><div><br></div><div><u>Key Take-aways from this lesson:</u>"    +
                                           "</div><div><ol><li>Learn why video is the preferred medium</li><li>How to "     +
                                           "choose a topic or discover one</li><li>Why you need to know your target "       +
                                           "market</li><li>Crafting a course title and description that sells</li></ol>"    +
                                           "</div>"
ifsimply_course2_lesson1.save

# IfSimply - Course 2 Lesson 2
ifsimply_course2_lesson2                 = ifsimply_course2.lessons.new
ifsimply_course2_lesson2.title           = "Lesson 2 - Outlining Your Course"
ifsimply_course2_lesson2.free            = true
ifsimply_course2_lesson2.background      = "<div>This video takes you through the critical steps of defining what your "   +
                                           "course will teach. This takes your topic and expands it to fit your audience " +
                                           "in a simple step by step fashion.</div><div><br></div><div><u>Key Take-aways " +
                                           "from this lesson:</u></div><div><ol><li>Must know your target audience and "   +
                                           "their experience level</li><li>Define your end goal of the course (what do "   +
                                           "they get out of it)</li><li>Take a step by step outline approach to defining " +
                                           "the lessons</li></ol></div>"
ifsimply_course2_lesson2.save

# IfSimply - Course 2 Lesson 3
ifsimply_course2_lesson3                 = ifsimply_course2.lessons.new
ifsimply_course2_lesson3.title           = "Lesson 3 - Producing Your First Lesson"
ifsimply_course2_lesson3.free            = true
ifsimply_course2_lesson3.background      = "This video takes you through the process of creating your course content and " +
                                           "recording that content into video.<div><br></div><div><u>Key Take-aways from " +
                                           "this lesson:</u></div><div><ol><li>You can use presentation with voiceover "   +
                                           "or \"Interview Style\"</li><li>Use readily available tools that work for you " +
                                           "(i.e. your laptop or iphone)</li><li>Post videos to youtube.com in "           +
                                           "\"unlisted\" format and paste on IfSimply.com<br></li></ol></div>"
ifsimply_course2_lesson3.save
