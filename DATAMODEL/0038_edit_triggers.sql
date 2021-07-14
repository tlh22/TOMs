/**
Triggers to deal with TOMs activity on insert/update/delete
**/

CREATE OR REPLACE FUNCTION mhtc_operations."getProposalNr"() RETURNS text AS
'SELECT current_setting(''toms.proposal_nr'', true);'
LANGUAGE SQL;

CREATE OR REPLACE FUNCTION mhtc_operations."restrictionInProposal"(restriction_id text, proposal_nr integer) RETURNS BOOLEAN
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    restriction_found BOOLEAN = 'false';
BEGIN

    -- Check to see if restriction exists in proposal
    SELECT true INTO restriction_found
    FROM toms."RestrictionsInProposals"
    WHERE "ProposalID" = proposal_nr
    AND "RestrictionID" = restriction_id;

    RETURN restriction_found;

END;
$$;

-- main trigger

CREATE OR REPLACE FUNCTION "mhtc_operations"."toms_edit_management"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    proposal_nr INTEGER;
    editingAllowed BOOLEAN = 'false';
BEGIN

    -- check if there is an active proposal being used
    SELECT mhtc_operations."getProposalNr"()::integer INTO proposal_nr;

    --RAISE NOTICE 'proposal_nr: [%]', proposal_nr;

	IF proposal_nr = 0 OR proposal_nr IS NULL THEN
	    RAISE NOTICE 'No active proposal. Changes not allowed ...';
    	RETURN OLD;
	END IF;

	RAISE NOTICE 'Active proposal. Using proposal % ...', proposal_nr;

    -- check if this user has the right to change data

    SELECT mhtc_operations."checkUserCredentials"() INTO editingAllowed;

    IF editingAllowed = 'false' THEN
    	RAISE NOTICE 'User not allowed to edit data ...';
    	RETURN OLD;
    END IF;

    -- for insert


    -- for update


    -- for delete

	RETURN NEW;

END;
$$;



CREATE TRIGGER "toms_management" BEFORE INSERT OR UPDATE ON "toms"."Bays" FOR EACH ROW EXECUTE FUNCTION "mhtc_operations"."toms_edit_management"();
