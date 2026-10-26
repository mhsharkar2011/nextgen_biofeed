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
