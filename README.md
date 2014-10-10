# Ruby on Rails: Challenge App

This is my second app. I found shell of app in github and I decided to face with it.
In this app I use slim instead of erb. I use also CoffeeScript.

The application is a question and answer site with features similar to [Stack Overflow](http://stackoverflow.com)

### Features to do

1. Users need to create profiles to add questions and answers.

2. Question has title and contents. Title should be required.

3. Answer has only contents. It should be required.

4. Users can update their questions, but not answers.

5. Users can like answers added by users. It should be visible how many likes each answer has received.

6. Question's author can accept one answer to the question. This answer should be marked as "Accepted".

7. No one can add new answer to a question that already has an accepted answer.

8. Users collect points. New users get 100 points for free.

9. When user's answer is accepted she receives 25 points, when liked she receives 5 points.

10. Creating a question costs 10 points.

  Answers and questions points are served by AJAX.

11. Users can set their names and it should be displayed everywhere instead of e-mail.

12. Users can upload avatars which should be automatically scaled to 100x100px size.

  Users can crop avatars, they are stored on Amazon S3 cloud.

13. Once a user reaches 1000 points, she receives Superstar badge that is visible on his profile page.

14. Question's author receives e-mail notification when someone answers his question.
15. User receives e-mail notification when his answer is accepted.

  Email notifications are optional, they could be disabled in Account settings


16. There is a leaderboard page where users are sorted by points.

  Instead it is possible to sort users by Username or by Points

17. E-mails are sent via background jobs.

  All emails are sent via background jobs. Devise mails are sent via sidekiq server and 'devise-async' gem, rest mails ('when new answer to my question' and 'when somebody accept my answer' are sent via redis server and sidekiq server - this is only avaliable in Development because free Heroku account gives only one job)
  To use async emails it is required to install and run 'redis' server -> redis-server and 'sidekiq' server -> bundle exec sidekiq
  On heroku I use SendGrid to send emails.

18. Users can login using their GitHub accounts.

  Users can also login using their google and facebook account.
  Users can set password and then sign in with this password or using omniauth. Users who sign up without omniauth or users who already set password need old password to change it.

19. Liking answers should not reload the page.

  Liking answers are in AJAX requests

20. Questions and aswers can be written in Markdown format.

  I used 'redcarpet' gem


### I also added:
1. I added bootstrap 3 framework and CSS styles.
2. There are real-time notifications with Pusher. They can review them, delete selecter or delete all.
3. Tags could be added to questions. It is possible to view questions with specified tag.
4. 'New question' and 'edit question' partials are displayed directly on page using AJAX. When user isn't signed in it redirects to sign in page.
5. If user has no Avatar it displays Gravatar. If user adds Avatar -> Avatar is displayed.

## My ChallangeApp on heroku
[*ChallangeApp*](http://whispering-thicket-9676.herokuapp.com/)

## link to Original README file
[*Original README*](https://github.com/marcinkornek/challangeApp/blob/master/original%20README.md)
