-- =============================================================================
-- MIGRATION: Add Email Verification Column
-- TICKET: DB-002
-- DESCRIPTION: Add email verification status tracking
-- =============================================================================

-- Check if column already exists
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'USERS' AND COLUMN_NAME = 'EMAIL_VERIFIED'
)
BEGIN
    ALTER TABLE USERS ADD 
        EMAIL_VERIFIED BIT DEFAULT 0,
        EMAIL_VERIFIED_AT DATETIME NULL;
    
    PRINT 'Column EMAIL_VERIFIED added to USERS table';
END
ELSE
BEGIN
    PRINT 'Column EMAIL_VERIFIED already exists';
END;

-- Add index for email verification queries
CREATE NONCLUSTERED INDEX idx_users_email_verified 
ON USERS(EMAIL_VERIFIED, EMAIL_VERIFIED_AT) 
WHERE EMAIL_VERIFIED = 1;

PRINT 'Migration completed successfully';
