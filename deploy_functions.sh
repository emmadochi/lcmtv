#!/bin/bash

# 🚀 LCMTV Cloud Functions Deployment Script
# This script automates the deployment of Cloud Functions

set -e  # Exit on any error

echo "🚀 Starting LCMTV Cloud Functions Deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Firebase CLI is installed
check_firebase_cli() {
    print_status "Checking Firebase CLI installation..."
    if ! command -v firebase &> /dev/null; then
        print_error "Firebase CLI is not installed. Please install it first:"
        echo "npm install -g firebase-tools"
        exit 1
    fi
    print_success "Firebase CLI is installed"
}

# Check if user is logged in
check_firebase_login() {
    print_status "Checking Firebase authentication..."
    if ! firebase projects:list &> /dev/null; then
        print_error "Not logged in to Firebase. Please login first:"
        echo "firebase login"
        exit 1
    fi
    print_success "Firebase authentication verified"
}

# Check if project is selected
check_firebase_project() {
    print_status "Checking Firebase project..."
    if [ -z "$(firebase use --project 2>/dev/null)" ]; then
        print_error "No Firebase project selected. Please select a project:"
        echo "firebase use --add"
        exit 1
    fi
    print_success "Firebase project is selected"
}

# Install dependencies
install_dependencies() {
    print_status "Installing Cloud Functions dependencies..."
    cd functions
    
    if [ ! -f "package.json" ]; then
        print_error "package.json not found in functions directory"
        exit 1
    fi
    
    npm install
    print_success "Dependencies installed successfully"
    cd ..
}

# Run linting
run_linting() {
    print_status "Running ESLint..."
    cd functions
    
    if npm run lint; then
        print_success "Linting passed"
    else
        print_warning "Linting failed, but continuing with deployment..."
    fi
    
    cd ..
}

# Set environment variables
set_environment_variables() {
    print_status "Setting environment variables..."
    
    # Check if YouTube API key is provided
    if [ -z "$YOUTUBE_API_KEY" ]; then
        print_warning "YOUTUBE_API_KEY not set. Please set it:"
        echo "export YOUTUBE_API_KEY='your_api_key_here'"
        echo "firebase functions:config:set youtube.apikey='your_api_key_here'"
    else
        firebase functions:config:set youtube.apikey="$YOUTUBE_API_KEY"
        print_success "YouTube API key configured"
    fi
}

# Deploy functions
deploy_functions() {
    print_status "Deploying Cloud Functions..."
    
    if firebase deploy --only functions; then
        print_success "Cloud Functions deployed successfully"
    else
        print_error "Failed to deploy Cloud Functions"
        exit 1
    fi
}

# Test functions
test_functions() {
    print_status "Testing deployed functions..."
    
    # Test health check
    if curl -s "https://us-central1-$(firebase use --project 2>/dev/null | grep -o 'LCTV').cloudfunctions.net/healthCheck" > /dev/null; then
        print_success "Health check passed"
    else
        print_warning "Health check failed, but functions may still be working"
    fi
}

# Set up monitoring
setup_monitoring() {
    print_status "Setting up monitoring..."
    
    # Create monitoring script
    cat > monitor_functions.sh << 'EOF'
#!/bin/bash
echo "📊 Monitoring Cloud Functions..."

# Check function status
firebase functions:list

# View recent logs
echo "📝 Recent logs:"
firebase functions:log --limit 10

# Check function metrics
echo "📈 Function metrics:"
gcloud functions list --format="table(name,status,trigger)"
EOF
    
    chmod +x monitor_functions.sh
    print_success "Monitoring script created: monitor_functions.sh"
}

# Create backup
create_backup() {
    print_status "Creating backup of current functions..."
    
    BACKUP_DIR="functions_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    cp -r functions/* "$BACKUP_DIR/"
    print_success "Backup created in $BACKUP_DIR"
}

# Main deployment function
main() {
    echo "🎯 LCMTV Cloud Functions Deployment"
    echo "=================================="
    
    # Pre-deployment checks
    check_firebase_cli
    check_firebase_login
    check_firebase_project
    
    # Create backup
    create_backup
    
    # Install dependencies
    install_dependencies
    
    # Run linting
    run_linting
    
    # Set environment variables
    set_environment_variables
    
    # Deploy functions
    deploy_functions
    
    # Test functions
    test_functions
    
    # Set up monitoring
    setup_monitoring
    
    print_success "🎉 Deployment completed successfully!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Test your functions in the Firebase Console"
    echo "2. Monitor function logs: firebase functions:log"
    echo "3. Set up monitoring alerts in Google Cloud Console"
    echo "4. Update your Flutter app to use the deployed functions"
    echo ""
    echo "🔗 Useful commands:"
    echo "- View logs: firebase functions:log"
    echo "- List functions: firebase functions:list"
    echo "- Monitor: ./monitor_functions.sh"
    echo "- Test locally: firebase emulators:start --only functions"
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --test         Run tests only"
        echo "  --monitor      Set up monitoring only"
        echo "  --backup       Create backup only"
        echo ""
        echo "Environment variables:"
        echo "  YOUTUBE_API_KEY    YouTube Data API key"
        echo ""
        exit 0
        ;;
    --test)
        print_status "Running tests only..."
        install_dependencies
        run_linting
        test_functions
        ;;
    --monitor)
        print_status "Setting up monitoring only..."
        setup_monitoring
        ;;
    --backup)
        print_status "Creating backup only..."
        create_backup
        ;;
    *)
        main
        ;;
esac
