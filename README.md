# Books Review Platform

## Overview

The **Books Review Platform** is a web application for managing books and their reviews. Users can create an account, add books, and leave reviews with ratings. The app supports search and sorting functionality to enhance user experience.

---

## Features

- User Authentication (Devise)
- Add, Edit, Delete Books
- Write, Edit, Delete Reviews
- Search and Sort Books by Title, Author, and Average Rating
- Responsive design with Bootstrap
- Turbo/Hotwire for creating and deleting Reviews

---

## Setup Instructions

### Prerequisites

Ensure you have the following installed:

- Ruby 3.0.0 or higher
- Rails 7.1.5 (I noticed the instructions mentioned using Rails 6, I can downgrade if needed)
- PostgreSQL database
- Node.js and Yarn

### Steps

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd books_review_platform
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Setup the database:

   ```bash
   rails db:create db:migrate db:seed
   ```

4. Start the Rails server:

   ```bash
   bin/rails server
   ```

5. Visit the app:
   Open `http://localhost:3000` in your browser.

---

## Assumptions and Trade-offs

### Assumptions

- **Book Ownership**: Only the user who created a book can edit or delete it.
- **Review Ownership**: Users can only edit or delete their own reviews.
- **Sorting**: Sorting options include Title, Author, and Average Rating.
- **Authentication**: User authentication is handled using Devise.

### Trade-offs

- **Bootstrap Design**: Bootstrap was used for styling to save time instead of creating custom CSS.
- **Pagination**: Implemented using Kaminari for simplicity.
- **Client-side Validation**: HTML5 validation is used instead of JavaScript validation for efficiency.

---

## Screenshots

### 1. Home Page with Book List

![home-screen](https://github.com/user-attachments/assets/adcb1371-af44-4763-944c-d0dbd1872083)

### 2. Add Book Page

![create-book](https://github.com/user-attachments/assets/340eb9a0-c169-486b-bc79-b0237c102618)

### 3. Book Details with Reviews

![book-show](https://github.com/user-attachments/assets/141c6dc0-7ad0-47b3-b092-0925a508d062)

### 4. User Profile Page

![profile](https://github.com/user-attachments/assets/68f1fae1-140a-4623-9657-6e101530af93)

---

## How to Run Tests

1. Run the RSpec test suite:

   ```bash
   bundle exec rspec
   ```

2. Ensure all tests pass before making changes or deploying.

---

## Future Improvements

- Enhance search to include fuzzy matching.
- Add image upload functionality for books.
- Implement API endpoints for integration with other systems.
- Improve accessibility features for visually impaired users.
