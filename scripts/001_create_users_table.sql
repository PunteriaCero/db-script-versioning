-- =============================================================================
-- MIGRATION: Create Users Table
-- TICKET: DB-001
-- DESCRIPTION: Initial schema for user management
-- =============================================================================

CREATE TABLE IF NOT EXISTS USERS (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    EMAIL NVARCHAR(255) NOT NULL UNIQUE,
    FIRST_NAME NVARCHAR(100),
    LAST_NAME NVARCHAR(100),
    CREATED_AT DATETIME DEFAULT GETUTCDATE(),
    UPDATED_AT DATETIME DEFAULT GETUTCDATE()
);

CREATE INDEX idx_users_email ON USERS(EMAIL);

-- Add audit columns
ALTER TABLE USERS ADD 
    CREATED_BY NVARCHAR(100) DEFAULT 'SYSTEM',
    MODIFIED_BY NVARCHAR(100) DEFAULT 'SYSTEM';

PRINT 'Table USERS created successfully';
