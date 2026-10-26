#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_step() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}STEP: $1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

# Check if project name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Usage: ./create-laravel-boilerplate.sh <project-name>${NC}"
    echo -e "${YELLOW}Example: ./create-laravel-boilerplate.sh my-app${NC}"
    exit 1
fi

PROJECT_NAME=$1

print_step "Creating Laravel project: $PROJECT_NAME"
composer create-project laravel/laravel "$PROJECT_NAME"

if [ $? -ne 0 ]; then
    print_error "Failed to create Laravel project"
    exit 1
fi

cd "$PROJECT_NAME" || exit

print_step "Installing Backend Dependencies"
composer require inertiajs/inertia-laravel
composer require tightenco/ziggy
composer require laravel/breeze --dev

print_step "Installing NPM Dependencies with legacy peer deps"
npm install --save-dev @inertiajs/react @inertiajs/inertia @inertiajs/inertia-react --legacy-peer-deps
npm install --save-dev react react-dom --legacy-peer-deps
npm install --save-dev @vitejs/plugin-react --legacy-peer-deps
npm install --save-dev tailwindcss @tailwindcss/forms @tailwindcss/typography --legacy-peer-deps
npm install --save-dev autoprefixer postcss --legacy-peer-deps
npm install --save-dev bootstrap @popperjs/core sass --legacy-peer-deps
npm install --save-dev @inertiajs/progress --legacy-peer-deps

print_step "Initializing Tailwind CSS"
npx tailwindcss init -p

print_step "Installing Laravel Breeze with React"
php artisan breeze:install react

print_step "Installing NPM dependencies after Breeze"
npm install --legacy-peer-deps

print_step "Creating necessary directories and files"

# Create additional directories
mkdir -p resources/js/Layouts
mkdir -p resources/js/Components
mkdir -p resources/js/Pages/Auth

# Configure tailwind.config.js
cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./resources/**/*.blade.php",
    "./resources/**/*.js",
    "./resources/**/*.jsx",
    "./resources/**/*.ts",
    "./resources/**/*.tsx",
    "./resources/**/*.vue",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],
}
EOF

# Configure vite.config.js
cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import react from '@vitejs/plugin-react';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.jsx'],
            refresh: true,
        }),
        react(),
    ],
    resolve: {
        alias: {
            '@': '/resources/js',
        },
    },
});
EOF

# Update resources/css/app.css - Remove bootstrap-icons import to avoid errors
cat > resources/css/app.css << 'EOF'
@import 'bootstrap/dist/css/bootstrap.min.css';
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
    body {
        @apply bg-gray-100;
    }
}

/* Custom Bootstrap overrides */
.btn-primary {
    @apply bg-blue-600 border-blue-600 hover:bg-blue-700 hover:border-blue-700;
}

.card {
    @apply border-0 rounded-lg shadow;
}

.card-header {
    @apply bg-white border-b-0 text-gray-700 font-semibold;
}
EOF

# Create bootstrap.js
cat > resources/js/bootstrap.js << 'EOF'
import 'bootstrap';
import * as bootstrap from 'bootstrap';

window.bootstrap = bootstrap;
EOF

# Create app.jsx
cat > resources/js/app.jsx << 'EOF'
import './bootstrap';
import '../css/app.css';

import { createInertiaApp } from '@inertiajs/react';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';
import { createRoot } from 'react-dom/client';

const appName = import.meta.env.VITE_APP_NAME || 'Laravel';

createInertiaApp({
    title: (title) => `${title} - ${appName}`,
    resolve: (name) => resolvePageComponent(
        `./Pages/${name}.jsx`,
        import.meta.glob('./Pages/**/*.jsx')
    ),
    setup({ el, App, props }) {
        const root = createRoot(el);
        root.render(<App {...props} />);
    },
    progress: {
        color: '#4B5563',
    },
});
EOF

# Create Welcome page
cat > resources/js/Pages/Welcome.jsx << 'EOF'
import { Head, Link } from '@inertiajs/react';

export default function Welcome({ auth, laravelVersion, phpVersion }) {
    return (
        <div className="min-vh-100 d-flex flex-column">
            <Head title="Welcome" />
            
            <nav className="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
                <div className="container">
                    <Link href="/" className="navbar-brand fw-bold">
                        <i className="bi bi-rocket-takeoff me-2 text-primary"></i>
                        Laravel Inertia
                    </Link>
                    
                    <div className="d-flex gap-2">
                        {auth.user ? (
                            <Link href="/dashboard" className="btn btn-primary">
                                Dashboard
                            </Link>
                        ) : (
                            <>
                                <Link href="/login" className="btn btn-outline-primary">
                                    Login
                                </Link>
                                <Link href="/register" className="btn btn-primary">
                                    Register
                                </Link>
                            </>
                        )}
                    </div>
                </div>
            </nav>

            <main className="flex-grow-1 d-flex align-items-center">
                <div className="container">
                    <div className="row justify-content-center text-center">
                        <div className="col-lg-8">
                            <h1 className="display-3 fw-bold mb-4">
                                Welcome to Laravel Inertia
                            </h1>
                            <p className="lead text-muted mb-4">
                                A modern Laravel + React + Inertia.js + Bootstrap + Tailwind CSS boilerplate
                            </p>
                            
                            <div className="d-flex gap-3 justify-content-center flex-wrap">
                                <Link href="/register" className="btn btn-primary btn-lg px-4">
                                    Get Started
                                    <i className="bi bi-arrow-right ms-2"></i>
                                </Link>
                                <Link href="/login" className="btn btn-outline-secondary btn-lg px-4">
                                    Sign In
                                </Link>
                            </div>

                            <div className="mt-5">
                                <div className="row g-4">
                                    <div className="col-md-4">
                                        <div className="card border-0 bg-light h-100">
                                            <div className="card-body">
                                                <div className="text-primary mb-3">
                                                    <i className="bi bi-layers fs-1"></i>
                                                </div>
                                                <h5>Laravel 11</h5>
                                                <p className="text-muted small">
                                                    Latest Laravel framework with powerful features
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div className="col-md-4">
                                        <div className="card border-0 bg-light h-100">
                                            <div className="card-body">
                                                <div className="text-primary mb-3">
                                                    <i className="bi bi-react fs-1"></i>
                                                </div>
                                                <h5>React 18</h5>
                                                <p className="text-muted small">
                                                    Reactive and composable components
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div className="col-md-4">
                                        <div className="card border-0 bg-light h-100">
                                            <div className="card-body">
                                                <div className="text-primary mb-3">
                                                    <i className="bi bi-bootstrap fs-1"></i>
                                                </div>
                                                <h5>Bootstrap 5</h5>
                                                <p className="text-muted small">
                                                    Modern UI components with Tailwind CSS
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    );
}
EOF

# Create Login page
cat > resources/js/Pages/Auth/Login.jsx << 'EOF'
import { useEffect } from 'react';
import { Head, Link, useForm } from '@inertiajs/react';

export default function Login({ status, canResetPassword }) {
    const { data, setData, post, processing, errors, reset } = useForm({
        email: '',
        password: '',
        remember: false,
    });

    useEffect(() => {
        return () => {
            reset('password');
        };
    }, []);

    const submit = (e) => {
        e.preventDefault();
        post(route('login'));
    };

    return (
        <div className="min-vh-100 d-flex align-items-center justify-content-center bg-light">
            <Head title="Login" />
            <div className="container">
                <div className="row justify-content-center">
                    <div className="col-md-6 col-lg-5">
                        <div className="card shadow-lg border-0">
                            <div className="card-body p-5">
                                <h2 className="text-center mb-4 fw-bold">Welcome Back</h2>
                                <p className="text-center text-muted mb-4">Sign in to your account</p>
                                
                                {status && (
                                    <div className="alert alert-success" role="alert">
                                        {status}
                                    </div>
                                )}

                                <form onSubmit={submit}>
                                    <div className="mb-3">
                                        <label htmlFor="email" className="form-label fw-semibold">Email Address</label>
                                        <input
                                            id="email"
                                            type="email"
                                            className={`form-control form-control-lg ${errors.email ? 'is-invalid' : ''}`}
                                            value={data.email}
                                            onChange={(e) => setData('email', e.target.value)}
                                            required
                                            autoFocus
                                            autoComplete="username"
                                            placeholder="name@example.com"
                                        />
                                        {errors.email && (
                                            <div className="invalid-feedback">{errors.email}</div>
                                        )}
                                    </div>

                                    <div className="mb-3">
                                        <label htmlFor="password" className="form-label fw-semibold">Password</label>
                                        <input
                                            id="password"
                                            type="password"
                                            className={`form-control form-control-lg ${errors.password ? 'is-invalid' : ''}`}
                                            value={data.password}
                                            onChange={(e) => setData('password', e.target.value)}
                                            required
                                            autoComplete="current-password"
                                            placeholder="Enter your password"
                                        />
                                        {errors.password && (
                                            <div className="invalid-feedback">{errors.password}</div>
                                        )}
                                    </div>

                                    <div className="mb-3 form-check">
                                        <input
                                            id="remember"
                                            type="checkbox"
                                            className="form-check-input"
                                            checked={data.remember}
                                            onChange={(e) => setData('remember', e.target.checked)}
                                        />
                                        <label htmlFor="remember" className="form-check-label">
                                            Remember me
                                        </label>
                                    </div>

                                    <div className="d-grid gap-2">
                                        <button 
                                            type="submit" 
                                            className="btn btn-primary btn-lg"
                                            disabled={processing}
                                        >
                                            {processing && (
                                                <span className="spinner-border spinner-border-sm me-2" role="status"></span>
                                            )}
                                            Sign In
                                        </button>
                                    </div>

                                    <div className="mt-4 text-center">
                                        {canResetPassword && (
                                            <Link href={route('password.request')} className="text-decoration-none me-3">
                                                Forgot Password?
                                            </Link>
                                        )}
                                        <Link href={route('register')} className="text-decoration-none">
                                            Create Account
                                        </Link>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
EOF

# Create Register page
cat > resources/js/Pages/Auth/Register.jsx << 'EOF'
import { useEffect } from 'react';
import { Head, Link, useForm } from '@inertiajs/react';

export default function Register() {
    const { data, setData, post, processing, errors, reset } = useForm({
        name: '',
        email: '',
        password: '',
        password_confirmation: '',
    });

    useEffect(() => {
        return () => {
            reset('password', 'password_confirmation');
        };
    }, []);

    const submit = (e) => {
        e.preventDefault();
        post(route('register'));
    };

    return (
        <div className="min-vh-100 d-flex align-items-center justify-content-center bg-light">
            <Head title="Register" />
            <div className="container">
                <div className="row justify-content-center">
                    <div className="col-md-6 col-lg-5">
                        <div className="card shadow-lg border-0">
                            <div className="card-body p-5">
                                <h2 className="text-center mb-4 fw-bold">Create Account</h2>
                                <p className="text-center text-muted mb-4">Join us today</p>

                                <form onSubmit={submit}>
                                    <div className="mb-3">
                                        <label htmlFor="name" className="form-label fw-semibold">Full Name</label>
                                        <input
                                            id="name"
                                            type="text"
                                            className={`form-control form-control-lg ${errors.name ? 'is-invalid' : ''}`}
                                            value={data.name}
                                            onChange={(e) => setData('name', e.target.value)}
                                            required
                                            autoFocus
                                            autoComplete="name"
                                            placeholder="John Doe"
                                        />
                                        {errors.name && (
                                            <div className="invalid-feedback">{errors.name}</div>
                                        )}
                                    </div>

                                    <div className="mb-3">
                                        <label htmlFor="email" className="form-label fw-semibold">Email Address</label>
                                        <input
                                            id="email"
                                            type="email"
                                            className={`form-control form-control-lg ${errors.email ? 'is-invalid' : ''}`}
                                            value={data.email}
                                            onChange={(e) => setData('email', e.target.value)}
                                            required
                                            autoComplete="username"
                                            placeholder="name@example.com"
                                        />
                                        {errors.email && (
                                            <div className="invalid-feedback">{errors.email}</div>
                                        )}
                                    </div>

                                    <div className="mb-3">
                                        <label htmlFor="password" className="form-label fw-semibold">Password</label>
                                        <input
                                            id="password"
                                            type="password"
                                            className={`form-control form-control-lg ${errors.password ? 'is-invalid' : ''}`}
                                            value={data.password}
                                            onChange={(e) => setData('password', e.target.value)}
                                            required
                                            autoComplete="new-password"
                                            placeholder="Create a password"
                                        />
                                        {errors.password && (
                                            <div className="invalid-feedback">{errors.password}</div>
                                        )}
                                    </div>

                                    <div className="mb-3">
                                        <label htmlFor="password_confirmation" className="form-label fw-semibold">
                                            Confirm Password
                                        </label>
                                        <input
                                            id="password_confirmation"
                                            type="password"
                                            className={`form-control form-control-lg ${errors.password_confirmation ? 'is-invalid' : ''}`}
                                            value={data.password_confirmation}
                                            onChange={(e) => setData('password_confirmation', e.target.value)}
                                            required
                                            autoComplete="new-password"
                                            placeholder="Confirm your password"
                                        />
                                        {errors.password_confirmation && (
                                            <div className="invalid-feedback">{errors.password_confirmation}</div>
                                        )}
                                    </div>

                                    <div className="d-grid gap-2">
                                        <button 
                                            type="submit" 
                                            className="btn btn-primary btn-lg"
                                            disabled={processing}
                                        >
                                            {processing && (
                                                <span className="spinner-border spinner-border-sm me-2" role="status"></span>
                                            )}
                                            Create Account
                                        </button>
                                    </div>

                                    <div className="mt-4 text-center">
                                        <Link href={route('login')} className="text-decoration-none">
                                            Already have an account? Sign in
                                        </Link>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
EOF

# Create Dashboard page
cat > resources/js/Pages/Dashboard.jsx << 'EOF'
import { Head, Link } from '@inertiajs/react';

export default function Dashboard({ auth }) {
    return (
        <>
            <Head title="Dashboard" />
            <div className="min-vh-100 bg-light">
                <nav className="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
                    <div className="container">
                        <Link href="/dashboard" className="navbar-brand fw-bold">
                            <i className="bi bi-speedometer2 me-2"></i>
                            Dashboard
                        </Link>
                        <div className="d-flex align-items-center">
                            <span className="navbar-text me-3">
                                <i className="bi bi-person-circle me-1"></i>
                                {auth.user.name}
                            </span>
                            <Link 
                                href={route('logout')} 
                                method="post" 
                                as="button"
                                className="btn btn-outline-danger btn-sm"
                            >
                                <i className="bi bi-box-arrow-right me-1"></i>
                                Logout
                            </Link>
                        </div>
                    </div>
                </nav>

                <main className="py-4">
                    <div className="container">
                        <div className="row justify-content-center">
                            <div className="col-md-8">
                                <div className="card shadow-sm border-0">
                                    <div className="card-header bg-white border-0 py-3">
                                        <h5 className="mb-0 fw-semibold">
                                            <i className="bi bi-grid-fill me-2 text-primary"></i>
                                            Dashboard
                                        </h5>
                                    </div>
                                    <div className="card-body">
                                        <div className="alert alert-success border-0" role="alert">
                                            <i className="bi bi-check-circle-fill me-2"></i>
                                            You are logged in!
                                        </div>

                                        <div className="row mt-4">
                                            <div className="col-md-6 mb-3">
                                                <div className="card bg-primary text-white border-0">
                                                    <div className="card-body">
                                                        <h6 className="card-title">Welcome</h6>
                                                        <p className="card-text display-6 fw-bold">
                                                            {auth.user.name}
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div className="col-md-6 mb-3">
                                                <div className="card bg-info text-white border-0">
                                                    <div className="card-body">
                                                        <h6 className="card-title">Email</h6>
                                                        <p className="card-text">
                                                            {auth.user.email}
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div className="mt-3 p-3 bg-light rounded">
                                            <h6 className="fw-semibold">Quick Actions</h6>
                                            <div className="d-flex gap-2 flex-wrap">
                                                <Link href="#" className="btn btn-outline-primary btn-sm">
                                                    <i className="bi bi-plus-circle me-1"></i>
                                                    Create New
                                                </Link>
                                                <Link href="#" className="btn btn-outline-secondary btn-sm">
                                                    <i className="bi bi-gear me-1"></i>
                                                    Settings
                                                </Link>
                                                <Link href="#" className="btn btn-outline-info btn-sm">
                                                    <i className="bi bi-question-circle me-1"></i>
                                                    Help
                                                </Link>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </>
    );
}
EOF

# Update routes/web.php
cat > routes/web.php << 'EOF'
<?php

use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
    ]);
});

Route::get('/dashboard', function () {
    return Inertia::render('Dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

require __DIR__.'/auth.php';
EOF

# Update .env file
if [ -f .env ]; then
    print_step "Updating .env file"
    sed -i 's/APP_NAME=Laravel/APP_NAME="Laravel Inertia Boilerplate"/' .env
    sed -i 's/VITE_APP_NAME="${APP_NAME}"/VITE_APP_NAME="Laravel Inertia Boilerplate"/' .env
fi

print_step "Running migrations"
php artisan migrate

print_step "Generating application key"
php artisan key:generate

print_step "Clearing caches"
php artisan optimize:clear

print_step "Building assets for production"
npm run build

print_step "Installation Complete! 🎉"

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✨ Boilerplate created successfully! ✨${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo -e "${YELLOW}To start the development server:${NC}"
echo -e "  cd $PROJECT_NAME"
echo -e "  composer run dev"
echo -e "  # Or in two separate terminals:"
echo -e "  php artisan serve"
echo -e "  npm run dev\n"

echo -e "${YELLOW}Default credentials after running migrations:${NC}"
echo -e "  You can register a new user at: http://localhost:8000/register\n"

echo -e "${YELLOW}Project structure:${NC}"
echo -e "  📁 $PROJECT_NAME/"
echo -e "  ├── 📁 app/"
echo -e "  ├── 📁 resources/"
echo -e "  │   ├── 📁 css/          # Tailwind + Bootstrap styles"
echo -e "  │   ├── 📁 js/           # React + Inertia components"
echo -e "  │   │   ├── 📁 Pages/    # Page components"
echo -e "  │   │   └── app.jsx     # Main entry point"
echo -e "  │   └── 📁 views/        # Blade templates"
echo -e "  ├── 📁 routes/"
echo -e "  ├── 📁 database/"
echo -e "  ├── vite.config.js       # Vite configuration"
echo -e "  ├── tailwind.config.js   # Tailwind configuration"
echo -e "  └── package.json\n"

echo -e "${GREEN}Happy coding! 🚀${NC}"