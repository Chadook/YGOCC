--Levelution Axelotl

function c30039203.initial_effect(c)

	--special summon self
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,30039213)
	e1:SetCondition(c30039203.spcon)
	e1:SetTarget(c30039203.sptg)
	e1:SetOperation(c30039203.spop)
	c:RegisterEffect(e1)
		if not c30039203.global_check then
		c30039203.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c30039203.checkop)
		Duel.RegisterEffect(ge1,0)
	end

	--sp summon Nebula
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,30039203)
	e2:SetCost(c30039203.lvcost)
	e2:SetTarget(c30039203.lvtg)
	e2:SetOperation(c30039203.lvop)
	c:RegisterEffect(e2)
end
	
function c30039203.checkop(e,tp,eg,ep,ev,re,r,rp)
	if (bit.band(r,REASON_BATTLE)>0 or bit.band(r,REASON_EFFECT)~=0) then
		Duel.RegisterFlagEffect(ep,30039203,RESET_PHASE+PHASE_END,0,1)
end
end
	
function c30039203.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,30039203)~=0
end

function c30039203.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c30039203.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
	end
	
function c30039203.lvfilter(c,e,tp)
	return c:IsCode(30039206) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c30039203.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c30039203.lvfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c30039203.spfilter(c,code)
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function c30039203.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-4
		and Duel.CheckReleaseGroup(tp,c30039203.spfilter,1,nil,30039201)
		and Duel.CheckReleaseGroup(tp,c30039203.spfilter,1,nil,30039202)
		and Duel.CheckReleaseGroup(tp,c30039203.spfilter,1,nil,30039203)
		and Duel.CheckReleaseGroup(tp,c30039203.spfilter,1,nil,30039204) end
		
	local g1=Duel.SelectReleaseGroup(tp,c30039203.spfilter,1,1,nil,30039201)
	local g2=Duel.SelectReleaseGroup(tp,c30039203.spfilter,1,1,nil,30039202)
	local g3=Duel.SelectReleaseGroup(tp,c30039203.spfilter,1,1,nil,30039203)
	local g4=Duel.SelectReleaseGroup(tp,c30039203.spfilter,1,1,nil,30039204)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	Duel.Release(g1,REASON_COST)
end

function c30039203.lvop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c30039203.lvfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end