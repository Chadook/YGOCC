--Levelution Adaptation

function c30039209.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c30039209.target)
	c:RegisterEffect(e1)
	
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,30039209)
	e2:SetCost(c30039209.spcost)
	e2:SetTarget(c30039209.sptg)
	e2:SetOperation(c30039209.spop)
	c:RegisterEffect(e2)
	
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,30039209)
	e3:SetCondition(c30039209.norcon)
	e3:SetCost(c30039209.norcost)
	e3:SetTarget(c30039209.nortg)
	e3:SetOperation(c30039209.norop)
	c:RegisterEffect(e3)
	
end
	
function c30039209.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c30039209.spcost(e,tp,eg,ep,ev,re,r,rp,0) and c30039209.sptg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(30039209,0)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		c30039209.spcost(e,tp,eg,ep,ev,re,r,rp,1)
		c30039209.sptg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c30039209.spop)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end

function c30039209.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x12F) and c:IsAbleToHandAsCost()
		and Duel.IsExistingMatchingCard(c30039209.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetCode())
end
function c30039209.spfilter(c,e,tp,code)
	return c:IsSetCard(0x12F) and not c:IsCode(code)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c30039209.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30039209.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c30039209.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end

function c30039209.spfilter2(c,e,tp)
	return c:IsSetCard(0x12F) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		--and Duel.IsExistingMatchingCard(c30039209.codefilter,tp,LOCATION_MZONE,0,1,nil,c:GetCode())
end
function c30039209.codefilter(c,code)
	return not c:IsCode(code)
end
function c30039209.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c30039209.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,30039209)==0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c30039209.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c30039209.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.RegisterFlagEffect(tp,30039209,RESET_PHASE+PHASE_END,0,1)
end

function c30039209.norcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,30039209)==0 
end
function c30039209.norcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c30039209.nortg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) end
end
function c30039209.norop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,30039209)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x12F))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,30039209,RESET_PHASE+PHASE_END,0,1)
end
