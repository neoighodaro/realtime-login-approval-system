# Login Approval System with Pusher Channels and Pusher Beams

How to build a login approval system using Pusher Channels and Pusher Beams.

Tutorial Links:

https://pusher.com/tutorials/login-approval-laravel-ios-part-1
https://pusher.com/tutorials/login-approval-laravel-ios-part-2
https://pusher.com/tutorials/login-approval-laravel-ios-part-3


## Getting Started

- Clone the repository.
- `cd` to the dashboard directory
- run `composer install`
- copy the `.env.example` file to `.env` and configure the file.
- run `php artisan migrate --seed`
- run `php artisan serve` to start the php server
- open the `./iosapp/dashboard.xcworkspace` file in xcode.
- customise the entries in the `AppConstants` class
- run the application

### Prerequisites

You need the following installed:

- [Xcode](https://developer.apple.com/xcode) 10.x or newer.
- [Laravel](https://laravel.com) CLI.
- [Composer](https://getcomposer.org) installed locally.

## Built With

- [Laravel](https://laravel.com) - Used to build the Laravel package.
- [Pusher](https://pusher.com/) - APIs to enable devs building realtime features
- [Swift](https://developer.apple.com/swift) - Swift programming language
