--Carole, Queen of Fiber Vine #2 
function c160009541.initial_effect(c)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x88)
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e1:SetCode(EFFECT_ADD_TYPE)
	--e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	--e1:SetValue(TYPE_NORMAL)
	--c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetValue(500314712)
	c:RegisterEffect(e2)
    --
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(160009541,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,160009541)
	e3:SetCondition(c160009541.discon)
	e3:SetCost(c160009541.discost)
	e3:SetTarget(c160009541.distg)
	e3:SetOperation(c160009541.disop)
	c:RegisterEffect(e3)
	--evolute summon
	--local e4=Effect.CreateEffect(c)
	--e4:SetDescription(aux.Stringid(160009541,0))
	--e4:SetCategory(CATEGORY_DESTROY)
	--e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	--e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e4:SetCondition(c160009541.descon)
	--e4:SetTarget(c160009541.destg)
	--e4:SetOperation(c160009541.desop)
	--c:RegisterEffect(e4)
	--Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(c160009541.checkop)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(160009541,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c160009541.spcon)
	e6:SetTarget(c160009541.sptg)
	e6:SetOperation(c160009541.spop)
	c:RegisterEffect(e6)
	if not c160009541.global_check then
		c160009541.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c160009541.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c160009541.evolute=true
c160009541.material1=function(mc) return mc:IsRace(RACE_PLANT) and mc:GetLevel()==4 and mc:IsFaceup() end
c160009541.material2=function(mc) return mc:IsAttribute(ATTRIBUTE_EARTH) and mc:GetLevel()==4 and mc:IsFaceup() end
function c160009541.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
end
--function c160009541.descon(e,tp,eg,ep,ev,re,r,rp)
--	Debug.Message("Appear, Queen of Cursed Fallen Warriors!")
--	return  e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+388
--end
--function c160009541.deesfilter(c)
	--return c:GetSummonLocation()==LOCATION_EXTRA and c:IsDestructable()
--end
--function c160009541.destg(e,tp,eg,ep,ev,re,r,rp,chk)
--	if chk==0 then return true end
--	local g=Duel.GetMatchingGroup(c160009541.deesfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
--	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
--end
--function c160009541.desop(e,tp,eg,ep,ev,re,r,rp)
--	local g=Duel.GetMatchingGroup(c160009541.deesfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
--	if g:GetCount()>0 then
--		Duel.Destroy(g,REASON_EFFECT)
--	end
--end
function c160009541.costfilter(c)
	return c:IsCode(500311028) and c:IsAbleToRemoveAsCost()
end
function c160009541.discon(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)
		and bit.band(re:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
		and Duel.IsChainNegatable(ev)
end
function c160009541.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,4,REASON_COST)
end
function c160009541.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c160009541.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c160009541.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCounter(0x88)>0 then
		c:RegisterFlagEffect(160009541,RESET_EVENT+0x17a0000,0,0)
	end
end
function c160009541.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and bit.band(r,REASON_EFFECT)~=0 and c:GetPreviousControler()==tp 
		and c:GetFlagEffect(160009541)>0
end
function c160009541.spfilter(c,e,tp)
	return c:IsCode(500314712) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c160009541.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c160009541.spfilter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c160009541.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c160009541.spfilter,tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
