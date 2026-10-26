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
