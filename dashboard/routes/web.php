<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::redirect('/', '/home');
Route::post('/login/confirm', 'Auth\LoginController@confirmLogin');
Route::post('/login/authorize', 'Auth\LoginController@authorizeLogin');
Route::post('/login/client-authorized', 'Auth\LoginController@clientAuthorized');

Auth::routes();

Route::get('/home', 'HomeController@index')->name('home');
